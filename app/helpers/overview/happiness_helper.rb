# frozen_string_literal: true

module Overview
  module HappinessHelper
    include Overview::BaseHelper

    def happiness
      data = date_range.map do |date|
        {
          'x' => date.strftime("%a, %B #{date.day.ordinalize}"),
          'y' => find_commmit_for_date(date)&.reflection&.happiness
        }
      end

      Oj.dump(data)
    end

    def average_happiness
      values = @seven_recent_commmits.filter_map { |c| c.reflection&.happiness }
      calculate_average(values)
    end
  end
end
