# frozen_string_literal: true

module Overview
  module GoalsHelper
    def average_goals_met
      reflections = @seven_recent_commmits.map(&:reflection)
      total_reflections = reflections.size

      return nil if total_reflections.size.zero?

      goals_met = reflections.count { |reflection| reflection&.goal_met == true }

      ((goals_met / (total_reflections * 1.0)) * 100).ceil(0)
    end
  end
end
