class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  extend FriendlyId
  friendly_id :username, use: :slugged
  
  validates :username, format: { with: /\A[a-z0-9]+\z/ }
  validates :username, :email, presence: true
  validates :github_user_id, :username, :email, uniqueness: true
  
  belongs_to :account
  belongs_to :team, optional: true
  has_many :retrospectives
  
  def sprint_tickets
    SprintTicket.where("'?' = ANY (sprint_tickets.github_user_ids)", github_user_id)
  end
end
