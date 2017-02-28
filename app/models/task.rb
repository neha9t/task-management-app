class Task < ApplicationRecord

  include SearchCop

  search_scope :search do
    attributes all: [:name, :description]
    options :all, type: :fulltext, default: true
  end

  validates :name, presence: true
  validates :user_id, presence: true
  validates :user_id, numericality: true, on: [:create, :update]
  # TODO: if time permits, try to do this.
  validates_date :end_date_on

  scope :author, ->(user_id) { where("user_id = ?", user_id) }
  # TODO: Why records of same date are returned.
  scope :tasks_after_date, ->(created_after) { where("created_at > ?", created_after) }
  # scope :before_end_date,  -> { order('end_date_on <= ?', :date) }
end
