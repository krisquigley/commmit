class Account < ApplicationRecord
  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true
  validates :subdomain, format: { with: /\A([a-z]+)\z/ }

  has_many :users
end
