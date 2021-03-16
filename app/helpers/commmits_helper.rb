# frozen_string_literal: true

module CommmitsHelper
  def percentage(commmit)
    ((@progress.to_f / commmit.planned_stories.size) * 100).round if @progress.positive?
  end

  def progress(commmit)
    commmit.planned_stories.map(&:completed_at).compact.count
  end
end
