class Team < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  validates :name, presence: true
  
  belongs_to :department
  has_many :sprints
  has_many :users
end