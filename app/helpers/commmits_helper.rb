# frozen_string_literal: true

module CommmitsHelper
  def percentage_left(total_number, current_number)
    percentage_done = current_number.positive? ? (current_number.to_f / total_number) * 100 : 0
    100 - percentage_done
  end
end
