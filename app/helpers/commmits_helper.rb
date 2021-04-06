# frozen_string_literal: true

module CommmitsHelper
  def percentage(planned_stories, completed_stories)
    ((@progress.to_f / (planned_stories.size + completed_stories.size)) * 100).round if @progress.positive?
  end

  def progress(completed_stories)
    completed_stories.size
  end
end
