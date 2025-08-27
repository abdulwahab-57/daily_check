class Todo < ApplicationRecord
  # Enums
  enum status: { todo: 0, in_progress: 1, blocked: 2, done: 3, canceled: 4 }
  enum priority: { low: 0, medium: 1, high: 2, urgent: 3 }

  # Associations
  belongs_to :project

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