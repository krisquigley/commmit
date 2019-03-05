class SprintTicket < ApplicationRecord
  validates :title, :estimated_effort, :issue_id, :repository_name, :number, :state, presence: true

  belongs_to :sprint, optional: true

  def estimated_effort
    estimated_effort_override || read_attribute(:estimated_effort)
  end
  
  def closed_at_formatted
    closed_at&.to_date&.to_formatted_s(:long) || 'Open'
  end

  def users
    User.where("github_user_id IN (?)", github_user_ids)
  end
end 