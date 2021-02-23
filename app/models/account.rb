class Account < ApplicationRecord
  def self.subdomain_format
    { with: /\A[A-Za-z0-9\-]+\z/, message: 'must only contain letters a-z, numbers 0-9 or the character -' }
  end
  
  has_one :user, inverse_of: :account
  
  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true, format: subdomain_format
end
