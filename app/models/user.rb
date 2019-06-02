class User < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  validates :name, :github_user_id, presence: true
  validates :github_user_id, uniqueness: true
  
  belongs_to :team, optional: true
  has_many :retrospectives
  has_and_belongs_to_many :sprints
  
  def sprint_tickets
    SprintTicket.where("'?' = ANY (sprint_tickets.github_user_ids)", github_user_id)
  end
end
