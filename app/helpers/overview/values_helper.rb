# frozen_string_literal: true

module Overview
  module ValuesHelper
    include Overview::BaseHelper

    def values
      values = @values.map { |v| { id: v.id, name: v.name, color: v.color } }

      value_data = values.map do |value|
        {
          'name' => value[:name],
          'type' => 'column',
          'data' => value_count_per_day(value[:id])
        }
      end

      return Oj.dump([]) if (value_data.count { |date_range_date| date_range_date['data'].count(nil) > 5 }) > 5

      Oj.dump(value_data)
    end

    def value_colors
      @values.map(&:color)
    end

    def value_count_per_day(value_id)
      date_range.map do |date|
        find_commmit_for_date(date)&.planned_stories&.count do |ps|
          ps.story.values.find { |v| v.id == value_id } if ps.completed_at.present?
        end
      end
    end
  end
end
