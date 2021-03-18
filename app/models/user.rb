# frozen_string_literal: true

class User < ApplicationRecord
  include ::AccountConcern

  default_scope -> { includes(:accounts) }

  extend FriendlyId
  friendly_id :username, use: :slugged

  before_create :downcase_username
  after_create :create_account
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :confirmable, :lockable, :trackable

  validates :username, format: subdomain_format
  validates :username, :email, presence: true, uniqueness: true

  has_and_belongs_to_many :accounts
  belongs_to :team, optional: true
  has_many :retrospectives

  def sprint_tickets
    SprintTicket.where("'?' = ANY (sprint_tickets.github_user_ids)", github_user_id)
  end

  def personal_account
    accounts.find_by(account_type: 'personal')
  end

  protected

  def downcase_username
    self.username = username.downcase
  end

  def create_account
    accounts.build(name: username, subdomain: username, account_type: 'personal', owner_user_id: id)
  end

  class CreateAccountError < StandardError; end
end
