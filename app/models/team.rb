class Team < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  validates :name, presence: true
  
  belongs_to :department
  has_many :sprints
  has_many :users

  def yesterdays_weather
    previous_sprints = sprints.where.not(final_velocity: nil).order(created_at: :desc).limit(3).pluck(:final_velocity)
    if !previous_sprints.empty?
      previous_sprints.inject(:+) / previous_sprints.count
    else
      0
    end
  end
end