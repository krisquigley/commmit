# frozen_string_literal: true

module Overview
  module BaseHelper
    def calculate_average(values)
      values.size.zero? ? nil : (values.sum / (values.size * 1.0)).ceil(2)
    end

    def date_range
      Range.new(Time.current.to_date - 7.days, Time.current.to_date - 1.day)
    end

    def formatted_date_range
      Oj.dump(date_range.map { |date| date.strftime("%a, %B #{date.day.ordinalize}") })
    end

    private

    def find_commmit_for_date(date)
      @seven_recent_commmits.find { |c| c.end_date == date }
    end
  end
end
