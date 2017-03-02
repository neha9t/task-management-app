class Task < ApplicationRecord

  # search_cop gem for full-text search
  include SearchCop

  search_scope :search do
    attributes all: [:name, :description]
    options :all, type: :fulltext, default: true
  end

  # validations
  validates :name, :user_id, presence: true
  validates :user_id, numericality: true, on: [:create, :update]
  validates_date :end_date_on

  # filters
  scope :author, ->(user_id) { where("user_id = ?", user_id) }
  scope :tasks_after_date, ->(created_after) { where("created_at > ?", created_after) }
  scope :before_end_date,  ->(before_date) { where('end_date_on < ?', before_date) }
end
