# frozen_string_literal: true

module CommmitsHelper
  def percentage_left(total_number, current_number)
    100 - percentage_done(total_number, current_number)
  end

  def percentage_done(total_number, current_number)
    current_number.positive? ? (current_number.to_f / total_number) * 100 : 0
  end

  def completed_planned_stories(commmit)
    commmit.planned_stories.count(&:completed_at)
  end

  def show_productivity?
    controller.controller_name == 'planned_stories' && controller.action_name == 'index' ||
      controller.controller_name == 'reflections'
  end
end
