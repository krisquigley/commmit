class Department < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  validates :name, presence: true

  has_many :teams
end