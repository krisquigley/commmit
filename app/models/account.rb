class Account < ApplicationRecord
  validates :name, presence: true
  def self.subdomain_format
    { with: /\A[A-Za-z0-9\-]+\z/, message: 'must only contain letters a-z, numbers 0-9 or the character -' }
  end
  validates :subdomain, presence: true, uniqueness: true, format: subdomain_format

  has_one :user
end
