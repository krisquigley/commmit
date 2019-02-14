class Team < ApplicationRecord
  validates :name, :user_ids, presence: true

  has_many :users
  has_many :sprints
end