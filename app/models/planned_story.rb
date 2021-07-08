# frozen_string_literal: true

class PlannedStory < ApplicationRecord
  acts_as_tenant :account

  after_update :complete_story

  belongs_to :commmit, touch: true
  belongs_to :story, touch: true

  scope :todo, -> { where(completed_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }

  default_scope -> { includes(:story) }

  def completed?
    completed_at.present?
  end

  def commmit_goal?
    commmit_goal
  end

  protected

  def complete_story
    story.update!(completed_at: completed_at)
  end
end
