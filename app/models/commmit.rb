class Commmit < ApplicationRecord
  acts_as_tenant :account

  validates :name, :length_in_days, presence: true
  validates :length_in_days, numericality: { only_integer: true, greater_than: 0 }
end