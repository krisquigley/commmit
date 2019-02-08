class User < ApplicationRecord
  validates :name, :github_user_id, presence: true
  
  belongs_to :team, optional: true
  
  def tickets
    Ticket.where("'?' = ANY (tickets.github_user_ids)", github_user_id)
  end
end
