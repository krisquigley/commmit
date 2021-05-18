# frozen_string_literal: true

module OverviewsHelper
  def date_range
    Range.new(Time.current.to_date - 8.days, Time.current.to_date - 1.day)
  end

  def productivity
    Oj.dump(date_range.map do |day|
      {
        'x' => day.to_formatted_s(:long),
        'y' => find_commmit_for_day(day)&.planned_stories&.count(&:completed_at) || 0
      }
    end)
  end

  def happiness
    Oj.dump(date_range.map do |day|
      {
        'x' => day.to_formatted_s(:long),
        'y' => find_commmit_for_day(day)&.reflection&.happiness || 0
      }
    end)
  end

  def average_productivity
    points = @seven_recent_commmits.map { |c| c.planned_stories.count(&:completed_at) }
    calculate_average(points)
  end

  def average_happiness
    values = @seven_recent_commmits.map { |c| c.reflection&.happiness }.compact
    calculate_average(values)
  end

  def calculate_average(values)
    values.size.zero? ? 0 : (values.sum / (values.size * 1.0)).ceil(2)
  end

  def find_commmit_for_day(day)
    @seven_recent_commmits.find { |c| c.end_date == day }
  end
end
