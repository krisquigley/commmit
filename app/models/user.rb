class User < ApplicationRecord
  default_scope -> { includes(:accounts) }
  scope :personal_account, -> { accounts.find(account_type: 'personal') }

  extend FriendlyId
  friendly_id :username, use: :slugged

  before_create :downcase_username
  after_create :create_account
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :confirmable, :lockable, :trackable
  
  validates :username, format: ::Account.subdomain_format
  validates :username, :email, presence: true, uniqueness: true
  
  has_and_belongs_to_many :accounts
  belongs_to :team, optional: true
  has_many :retrospectives
  
  def sprint_tickets
    SprintTicket.where("'?' = ANY (sprint_tickets.github_user_ids)", github_user_id)
  end

  protected

  def downcase_username
    self.username = self.username.downcase
  end

  def create_account
    self.accounts << Account.create!(name: self.username, subdomain: self.username, account_type: 'personal', owner_user_id: self.id)
  rescue StandardError => error 
    self.destroy!
    raise CreateAccountError, error
  end

  def send_devise_notification(notification, *args)
    # Queue email through sidekiq
    super
    
    # devise_mailer.send(notification, self, *args).deliver_later
  end

  class CreateAccountError < StandardError; end
end
