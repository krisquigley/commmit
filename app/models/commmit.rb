# frozen_string_literal: true

class Commmit < ApplicationRecord
  include Discard::Model

  acts_as_tenant :account
  auto_strip_attributes :name

  scope :most_recent_first, -> { order(start_date: :desc) }
  scope :current, lambda {
    where('start_date <= ? AND end_date >= ?', Time.current.to_date, Time.current.to_date)
      .kept
      .limit(1)
  }
  scope :completed, lambda {
    order(end_date: :desc)
      .where('end_date < ?', Time.current.to_date)
  }

  validates :name, :length_in_days, :end_date, :start_date, presence: true
  validates :length_in_days, numericality: { only_integer: true, greater_than: 0 }

  has_many :planned_stories, dependent: :destroy
  has_many :stories, through: :planned_stories

  after_create :automatically_add_repeatable_stories
  before_validation :set_end_date

  def reflected?
    false
  end

  def finished?
    end_date < Time.current.to_date
  end

  def in_progress?
    start_date <= Time.current.to_date && end_date >= Time.current.to_date
  end

  def not_started?
    start_date > Time.current.to_date
  end

  def self.active_commmits?
    Commmit.current.size.positive?
  end

  private

  def automatically_add_repeatable_stories
    Story.automatic.in_batches do |batch|
      batch.each do |story|
        planned_stories.create(story: story)
      end
    end
  end

  def set_end_date
    self.end_date = start_date + (length_in_days - 1)
  end
end
