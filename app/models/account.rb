# frozen_string_literal: true

class Account < ApplicationRecord
  include ::AccountConcern

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_and_belongs_to_many :users

  validates :name, :account_type, presence: true
  validates :owner_user_id, presence: true, if: -> { account_type == 'personal' }
  validates :subdomain, presence: true, uniqueness: true, format: subdomain_format
end
