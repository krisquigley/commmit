# frozen_string_literal: true

module OverviewsHelper
  def productivity
    Oj.dump(@seven_recent_commmits.map do |commmit|
      next if commmit.in_progress?

      {
        'x' => commmit.end_date.to_formatted_s(:long),
        'y' => commmit.planned_stories.count(&:completed_at)
      }
    end.reverse)
  end

  def average_productivity
    points = @seven_recent_commmits.map { |c| c.planned_stories.count(&:completed_at) }

    points.sum / points.size
  end
end
