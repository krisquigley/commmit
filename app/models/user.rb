class User < ApplicationRecord
  default_scope -> { includes(:account) }
  extend FriendlyId
  friendly_id :username, use: :slugged

  before_create :downcase_username
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :confirmable, :lockable, :trackable
  
  validates :username, format: ::Account.subdomain_format
  validates :username, :email, presence: true, uniqueness: true
  
  belongs_to :account, inverse_of: :user
  validates_presence_of :account
  belongs_to :team, optional: true
  has_many :retrospectives
  
  def sprint_tickets
    SprintTicket.where("'?' = ANY (sprint_tickets.github_user_ids)", github_user_id)
  end

  protected

  def downcase_username
    self.username = self.username.downcase
  end

  def send_devise_notification(notification, *args)
    # Queue email through sidekiq
    super
    
    # devise_mailer.send(notification, self, *args).deliver_later
  end
end
