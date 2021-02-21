class User < ApplicationRecord
  before_validation :create_account, on: :create
  before_create :downcase_username
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  extend FriendlyId
  friendly_id :username, use: :slugged
  
  validates :username, format: ::Account.subdomain_format
  validates :username, :email, presence: true
  validates :github_user_id, :username, :email, uniqueness: true
  
  belongs_to :account
  belongs_to :team, optional: true
  has_many :retrospectives
  
  def sprint_tickets
    SprintTicket.where("'?' = ANY (sprint_tickets.github_user_ids)", github_user_id)
  end

  private

  def downcase_username
    self.username = self.username.downcase
  end

  def create_account
    self.account = Account.create!(name: self.username.downcase, subdomain: self.username.downcase)
  end  
end
