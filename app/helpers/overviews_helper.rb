# frozen_string_literal: true

module OverviewsHelper
  def date_range
    Range.new(Time.current.to_date - 7.days, Time.current.to_date - 1.day)
  end

  def formatted_date_range
    Oj.dump(date_range.map { |d| d.to_formatted_s(:long) })
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

  def values
    values = @values.map { |v| { id: v.id, name: v.name, color: v.color } }

    value_data = values.map do |value|
      {
        'name' => value[:name],
        'data' => value_count_per_day(value[:id])
      }
    end

    Oj.dump(value_data)
  end

  def value_colors
    @values.map(&:color)
  end

  def average_productivity
    points = @seven_recent_commmits.map { |c| c.planned_stories.count(&:completed_at) }
    calculate_average(points)
  end

  def average_happiness
    values = @seven_recent_commmits.filter_map { |c| c.reflection&.happiness }
    calculate_average(values)
  end

  def calculate_average(values)
    values.size.zero? ? 0 : (values.sum / (values.size * 1.0)).ceil(2)
  end

  def average_goals_met
    reflections = @seven_recent_commmits.map(&:reflection)
    total_reflections = reflections.size

    return 0 if total_reflections.size.zero?

    goals_met = reflections.count { |reflection| reflection&.goal_met == true }

    ((goals_met / (total_reflections * 1.0)) * 100).ceil(0)
  end

  private

  def find_commmit_for_day(day)
    @seven_recent_commmits.find { |c| c.end_date == day }
  end

  def value_count_per_day(value_id)
    date_range.map do |day|
      find_commmit_for_day(day)&.planned_stories&.count do |ps|
        ps.story.values.find { |v| v.id == value_id } if ps.completed_at.present?
      end || 0
    end || 0
  end
end
