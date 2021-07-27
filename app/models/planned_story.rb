# frozen_string_literal: true

class PlannedStory < ApplicationRecord
  acts_as_tenant :account

  before_update :complete_story, if: -> { completed_at_changed? }

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

  def mark_as_done
    update(completed_at: Time.current)
  end

  def mark_as_not_done
    update(completed_at: nil)
  end

  private

  def complete_story
    # Set completed_at date to previous date if repeatable story and marking as not done
    if completed_at.nil? && story.repeatable?
      planned_stories = story.planned_stories.completed.where.not(id: id).order(created_at: :desc).limit(1)

      story.update!(completed_at: planned_stories.first&.completed_at || completed_at)
    else
      story.update!(completed_at: completed_at)
    end
  end
end
