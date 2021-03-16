# frozen_string_literal: true

class PlannedStory < ApplicationRecord
  acts_as_tenant :account

  after_update :complete_story, if: -> { completed_at.present? && !story.repeatable? }

  belongs_to :commmit
  belongs_to :story

  def completed?
    completed_at.present?
  end

  protected

  def complete_story
    story.update!(completed_at: completed_at)
  end
end
