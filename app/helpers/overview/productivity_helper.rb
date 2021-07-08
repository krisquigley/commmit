# frozen_string_literal: true

module Overview
  module ProductivityHelper
    include Overview::BaseHelper

    def productivity
      data = date_range.map do |date|
        {
          'x' => date.strftime("%a, %B #{date.day.ordinalize}"),
          'y' => find_commmit_for_date(date)&.planned_stories&.count(&:completed_at)
        }
      end

      Oj.dump(data)
    end

    def average_productivity
      points = @seven_recent_commmits.map { |c| c.planned_stories.count(&:completed_at) }
      calculate_average(points)
    end
  end
end
