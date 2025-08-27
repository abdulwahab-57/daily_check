class Project < ApplicationRecord
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
