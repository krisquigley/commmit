class Team < ApplicationRecord
  validates :name, presence: true

  has_many :users
  has_many :sprints
end