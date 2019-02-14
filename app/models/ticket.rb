class Ticket < ApplicationRecord
  validates :title, :estimated_effort, :issue_id, :repository_name, :number, :state, presence: true
  validates :issue_id, uniqueness: true
end