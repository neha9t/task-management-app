class Task < ApplicationRecord
  validates :name, presence: true
  validates :user_id, presence: true
  validates :user_id, numericality: true, on: [:create, :update]
  # TODO - if time permits, try to do this.
  validates_date :end_date_on

  scope :author,       -> (user_id) { where('user_id = ?', user_id) }
  # TODO - Does having updated_at here make sense?
  scope :tasks_after_date, -> (created_after) { order('created_at >= ?', created_after) }
  #scope :before_end_date,  -> { order('end_date_on <= ?', :date) }
end
