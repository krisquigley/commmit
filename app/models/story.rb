# frozen_string_literal: true

class Story < ApplicationRecord
  include Discard::Model

  acts_as_tenant :account

  extend FriendlyId
  friendly_id :goal, use: :scoped, scope: :account

  validates :goal, presence: true

  scope :most_recent_first, -> { order(created_at: :desc) }
  scope :open, -> { where(completed_at: nil) }

  has_many :planned_stories
  has_many :commmits, counter_cache: true, through: :planned_stories
  has_and_belongs_to_many :tags

  def completed?
    completed_at.present?
  end

  def repeatable?
    repeatable
  end
end
