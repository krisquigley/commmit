# frozen_string_literal: true

class Story < ApplicationRecord
  include Discard::Model

  acts_as_tenant :account

  after_create_commit :broadcast_story

  auto_strip_attributes :goal, :reason, :notes
  validates :goal, presence: true
  validates :automatically_add, exclusion: [true], if: -> { repeatable == false }

  scope :most_recent_first, -> { order(created_at: :desc) }
  scope :completed_first, -> { order(completed_at: :desc, created_at: :desc) }

  scope :one_off, -> { where(repeatable: false) }
  scope :repeatable, -> { where(repeatable: true) }
  scope :complete, -> { where.not(completed_at: nil) }
  scope :incomplete, -> { where(completed_at: nil) }
  scope :automatic, -> { repeatable.where(automatically_add: true) }

  has_many :planned_stories
  has_many :commmits, counter_cache: true, through: :planned_stories
  has_and_belongs_to_many :values

  def completed?
    completed_at.present?
  end

  def repeatable?
    repeatable
  end

  def automatic?
    automatically_add
  end

  private

  def broadcast_story
    if self.repeatable?
      broadcast_prepend_to action: 'repeatable_stories', target: 'repeatable_stories'
    else
      broadcast_prepend_to action: 'one_off_stories', target: 'one_off_stories'
    end
  end
end
