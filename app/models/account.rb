class Account < ApplicationRecord
  validates :name, :subdomain, presence: true, uniqueness: true
  validates :subdomain, format: { with: /\A([a-z]+)\z/ }
end
