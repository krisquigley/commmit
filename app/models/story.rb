# frozen_string_literal: true

class Story < ApplicationRecord
  acts_as_tenant :account

  extend FriendlyId
  friendly_id :goal, use: :slugged

  validates :goal, presence: true

  scope :most_recent_first, -> { order(created_at: :desc) }
  scope :open, -> { where(completed_at: nil) }

  has_many :planned_stories
  has_many :commmits, counter_cache: true, through: :planned_stories

  def completed?
    completed_at.present?
  end
end
