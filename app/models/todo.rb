class Todo < ApplicationRecord
  include AASM

  aasm column: :status do
    state :todo, initial: true
    state :in_progress
    state :blocked
    state :done
    state :canceled

    event :start do
      transitions from: :todo, to: :in_progress
    end

    event :block do
      transitions from: [ :todo, :in_progress ], to: :blocked
    end

    event :unblock do
      transitions from: :blocked, to: :todo
    end

    event :complete do
      transitions from: [ :todo, :in_progress, :blocked ], to: :done,
                  guard: :all_subtasks_completed?
      after do
        update_project_status
        set_completed_at
      end
    end

    event :cancel do
      transitions from: [ :todo, :in_progress, :blocked ], to: :canceled
    end
  end

  def all_subtasks_completed?
    return true if subtasks.empty?
    subtasks.where.not(status: [ :done, :canceled ]).empty?
  end

  def update_project_status
    return unless project.active?
    project.complete! if project.may_complete? && project.all_todos_completed?
  end

  # Helper methods for the views/controllers
  def available_events
    aasm.events(permitted: true).map(&:name)
  end

  def can_transition_to?(event)
    aasm.may_fire_event?(event.to_sym)
  end

  # Enums
  enum status: { todo: 0, in_progress: 1, blocked: 2, done: 3, canceled: 4 }
  enum priority: { low: 0, medium: 1, high: 2, urgent: 3 }

  # Associations
  belongs_to :project

  # Self-referential association for subtasks
  belongs_to :parent, class_name: "Todo", optional: true
  has_many :subtasks, class_name: "Todo", foreign_key: "parent_id", dependent: :destroy

  # Scopes
  scope :parent_tasks, -> { where(parent_id: nil).includes(:subtasks) }

  # Associations validations
  validates :project, presence: true

  # Validations
  validates :title, :project_id, :status, :priority, presence: true

  validates :estimate_minutes, :time_spent_minutes, numericality: { greater_than_or_equal_to: 0 }

  validate :starts_before_completion
  def starts_before_completion
    return if starts_at.blank? || completed_at.blank?
    errors.add(:completed_at, "cannot be before starts_at") if completed_at < starts_at
  end

  validate :due_date_not_past, unless: :done?
  def due_date_not_past
    return if due_date.blank?
    errors.add(:due_date, "cannot be in the past") if due_date < Date.today
  end

  # Callbacks
  before_save :set_completed_at
  def set_completed_at
    self.completed_at ||= Time.current if done?
  end

  after_create :update_project_counters
  def update_project_counters
    project.increment!(:todos_count)
    project.increment!(:completed_todos_count) if done?
  end

  after_destroy :decrement_project_counters
  def decrement_project_counters
    project.decrement!(:todos_count)
    project.decrement!(:completed_todos_count) if done?
  end
end
