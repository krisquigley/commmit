class Ticket < ApplicationRecord
  validates :title, :estimated_effort, :issue_id, :repository_name, :number, :state, presence: true

  belongs_to :sprint, optional: true
  has_and_belongs_to_many :users, optional: true

  def actual_effort
    read_attribute(:actual_effort) || "N/A"
  end

  def closed_at
    read_attribute(:closed_at) || 'Unmerged'
  end
end