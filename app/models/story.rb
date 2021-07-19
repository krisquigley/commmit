# frozen_string_literal: true

class Story < ApplicationRecord
  include Discard::Model

  acts_as_tenant :account

  after_create_commit :broadcast_prepend
  after_update_commit :broadcast_replace

  auto_strip_attributes :goal, :reason, squish: true
  auto_strip_attributes :notes
  validates :goal, presence: true
  validates :automatically_add, exclusion: [true], if: -> { repeatable == false }

  scope :most_recent_first, -> { order(created_at: :desc) }
  scope :completed_first, -> { order(created_at: :desc, completed_at: :desc) }

  scope :one_off, -> { where(repeatable: false) }
  scope :repeatable, -> { where(repeatable: true) }
  scope :complete, -> { where.not(completed_at: nil) }
  scope :incomplete, -> { where(completed_at: nil) }
  scope :automatic, -> { repeatable.where(automatically_add: true) }

  has_many :planned_stories
  has_many :commmits, counter_cache: true, through: :planned_stories
  has_and_belongs_to_many :values

  after_save do
    planned_stories.update_all updated_at: Time.current
  end

  def completed?
    completed_at.present?
  end

  def repeatable?
    repeatable
  end

  def one_off?
    !repeatable?
  end

  def automatic?
    automatically_add
  end

  private

  def broadcast_prepend
    stream = repeatable ? 'repeatable_stories' : 'one_off_stories'

    broadcast_prepend_to account_id, stream
  end

  def broadcast_replace
    stream = repeatable ? 'repeatable_stories' : 'one_off_stories'

    if discarded_at
      broadcast_remove
    else
      broadcast_replace_to account_id, stream
    end
  end

  def broadcast_remove
    stream = repeatable ? 'repeatable_stories' : 'one_off_stories'

    broadcast_remove_to account_id, stream
  end
end
