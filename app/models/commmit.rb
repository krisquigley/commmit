# frozen_string_literal: true

class Commmit < ApplicationRecord
  include Discard::Model

  acts_as_tenant :account

  auto_strip_attributes :name
  scope :most_recent_first, -> { order(start_date: :desc) }

  # TODO: should match 'in progress' logic
  scope :current_commmit, lambda {
                            order(start_date: :desc, created_at: :desc)
                              .where('start_date <= ?', Time.current.to_date)
                              .limit(1)
                              .first
                          }

  validates :name, :length_in_days, presence: true
  validates :length_in_days, numericality: { only_integer: true, greater_than: 0 }

  has_many :planned_stories, dependent: :destroy
  has_many :stories, through: :planned_stories

  after_create :automatically_add_repeatable_stories

  def reflected?
    false
  end

  def finished?
    end_date < Time.current.to_date
  end

  def end_date
    start_date + (length_in_days - 1)
  end

  def in_progress?
    start_date <= Time.current.to_date && end_date >= Time.current.to_date
  end

  def not_started?
    start_date > Time.current.to_date
  end

  def no_active_commmits?
    !Commmit.current_commmit.present?
  end

  def automatically_add_repeatable_stories
    Story.automatic.in_batches do |batch|
      batch.each do |story|
        planned_stories.create(story: story)
      end
    end
  end
end
