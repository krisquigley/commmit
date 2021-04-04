# frozen_string_literal: true

class Account < ApplicationRecord
  include ::AccountConcern

  has_and_belongs_to_many :users
  has_many :commmits, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :teams, dependent: :destroy

  validates :name, :account_type, presence: true
  validates :owner_user_id, presence: true, if: -> { account_type == 'personal' }
  validates :subdomain, presence: true, uniqueness: true, format: subdomain_format
end
