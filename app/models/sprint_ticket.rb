class SprintTicket < ApplicationRecord
  validates :title, :estimated_effort, :issue_id, :repository_name, :number, :state, presence: true

  belongs_to :sprint, optional: true
  has_many :users, foreign_key: :github_user_id, primary_key: :github_user_ids

  def actual_effort
    read_attribute(:actual_effort) || 0
  end

  def closed_at
    read_attribute(:closed_at)&.to_date&.to_formatted_s(:long) || 'Unmerged'
  end
end