# frozen_string_literal: true

class Commmit < ApplicationRecord
  acts_as_tenant :account

  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :account

  scope :most_recent_first, -> { order(start_date: :desc) }

  scope :current_commmit, lambda {
                            order(start_date: :desc, created_at: :desc).where('start_date <= ?', Date.today).first
                          }

  validates :name, :length_in_days, presence: true
  validates :length_in_days, numericality: { only_integer: true, greater_than: 0 }

  has_many :planned_stories, dependent: :destroy
  has_many :stories, through: :planned_stories

  has_and_belongs_to_many :tags

  def finished?
    end_date < Date.today
  end

  def end_date
    start_date + (length_in_days - 1)
  end

  def in_progress?
    start_date <= Date.today && end_date <= Date.today + (length_in_days - 1)
  end

  def not_started?
    start_date > Date.today
  end
end
