# frozen_string_literal: true

module StoriesHelper
  def completed_or_added(story)
    if story.repeatable? && story.completed?
      "#{t('stories.index.last_completed')} #{time_ago_in_words(story.completed_at)} #{t('stories.index.ago')}"
    else
      "#{t('stories.index.added')} #{time_ago_in_words(story.created_at)} #{t('stories.index.ago')}"
    end
  end
end
