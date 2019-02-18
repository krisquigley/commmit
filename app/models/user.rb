class User < ApplicationRecord
  validates :name, :github_user_id, presence: true
  validates :github_user_id, uniqueness: true
  
  belongs_to :team, optional: true
  
  def sprint_tickets
    SprintTicket.where("'?' = ANY (sprint_tickets.github_user_ids)", github_user_id)
  end
end
