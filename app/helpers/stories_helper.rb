# frozen_string_literal: true

module StoriesHelper
  def completed_or_added(story)
    if story.repeatable? && story.completed?
      # TODO: this should be calculated from the most recent completed planned story rather than the story itself
      t('stories.index.last_completed')
    else
      t('stories.index.added')
    end
  end
end
