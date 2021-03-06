# frozen_string_literal: true

class Account < ApplicationRecord
  def self.subdomain_format
    { with: /\A[A-Za-z0-9\-]+\z/,
      message: 'must only contain letters a-z, numbers 0-9 and the character -' }
  end

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_and_belongs_to_many :users

  validates :name, :account_type, presence: true
  validates :owner_user_id, presence: true, if: -> { account_type == 'personal' }
  validates :subdomain, presence: true, uniqueness: true, format: subdomain_format
end
