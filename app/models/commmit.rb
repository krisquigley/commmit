# frozen_string_literal: true

class Commmit < ApplicationRecord
  include Discard::Model

  acts_as_tenant :account
  auto_strip_attributes :name

  scope :most_recent_first, -> { order(end_date: :desc) }
  scope :current, lambda {
    where(end_date: Time.current.to_date)
      .kept
  }
  scope :completed, lambda {
    order(end_date: :desc)
      .where('end_date < ?', Time.current.to_date)
      .kept
  }

  before_validation :set_end_date

  validates :name, :end_date, presence: true
  validates_uniqueness_of :end_date, scope: :account_id, conditions: -> { where(discarded_at: nil) }

  has_many :planned_stories, dependent: :destroy
  has_many :stories, through: :planned_stories
  has_one :reflection, dependent: :destroy

  after_create :automatically_add_repeatable_stories

  def reflected?
    reflection.present?
  end

  def finished?
    end_date < Time.current.to_date || reflected?
  end

  def in_progress?
    !finished? && end_date == Time.current.to_date
  end

  def self.active_commmits?
    Commmit.current.count.positive?
  end

  private

  def automatically_add_repeatable_stories
    Story.automatic.kept.in_batches do |batch|
      batch.each do |story|
        planned_stories.create(story: story)
      end
    end
  end

  def set_end_date
    self.end_date = Time.current.to_date unless end_date
  end
end
