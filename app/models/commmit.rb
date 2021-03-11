# frozen_string_literal: true

class Commmit < ApplicationRecord
  acts_as_tenant :account

  extend FriendlyId
  friendly_id :name, use: :slugged

  scope :most_recent_first, -> { order(start_date: :desc) }

  validates :name, :length_in_days, presence: true
  validates :length_in_days, numericality: { only_integer: true, greater_than: 0 }

  has_many :planned_stories
  has_many :stories, through: :planned_stories

  def finished?
    end_date < Date.today
  end

  def end_date
    return start_date if length_in_days == 1

    start_date + length_in_days
  end

  def in_progress?
    start_date <= Date.today && end_date <= Date.today + length_in_days
  end

  def not_started?
    start_date > Date.today
  end
end
