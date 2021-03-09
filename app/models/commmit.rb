# frozen_string_literal: true

class Commmit < ApplicationRecord
  acts_as_tenant :account

  extend FriendlyId
  friendly_id :name, use: :slugged

  scope :most_recent, -> { order(created_at: :desc) }

  validates :name, :length_in_days, presence: true
  validates :length_in_days, numericality: { only_integer: true, greater_than: 0 }

  has_many :stories

  def finished?
    end_date < Date.today
  end

  def end_date
    start_date + length_in_days
  end

  def in_progress?
    start_date <= Date.today && end_date <= Date.today
  end

  def not_started?
    start_date > Date.today
  end
end
