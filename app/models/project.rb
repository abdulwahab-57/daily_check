class Project < ApplicationRecord
  include AASM

  aasm column: :status, enum: true do
    state :draft, initial: true
    state :active
    state :archived
    state :completed

    event :activate do
      transitions from: :draft, to: :active
    end

    event :archive do
      transitions from: [ :draft, :active ], to: :archived
    end

    event :complete do
      transitions from: :active, to: :completed, guard: :all_todos_completed?
      after do
        # Optional: Mark remaining todos as completed
      end
    end

    event :reopen do
      transitions from: [ :archived, :completed ], to: :active
    end
  end

  def all_todos_completed?
    todos.where.not(status: [ :done, :canceled ]).empty?
  end

  # Helper methods for the views/controllers
  def available_events
    aasm.events(permitted: true).map(&:name)
  end

  def can_transition_to?(event)
    aasm.may_fire_event?(event.to_sym)
  end

  # Enums
  enum status: { draft: 0, active: 1, archived: 2, completed: 3 }

  # Associations
  has_many :todos, dependent: :destroy

  # Callback Before validation
  before_validation :set_slug, if: -> { name.present? && slug.blank? }

  # Validations
  validates :name, presence: true

  validates :status, presence: true

  validates :slug, presence: true, uniqueness: true

  validates_format_of :slug, with: /\A[a-z0-9-]+\z/, message: "only allows lowercase letters, numbers and hyphens"

  validates :todos_count, :completed_todos_count, numericality: { greater_than_or_equal_to: 0 }

  validate :start_date_before_due_date
  def start_date_before_due_date
    return if start_date.blank? || due_date.blank?
    errors.add(:due_date, "must be after start date") if due_date < start_date
  end


  private
  def set_slug
    self.slug = name.parameterize
  end
end
