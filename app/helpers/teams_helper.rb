module TeamsHelper
  def happiness_values(happiness)
    puts happiness.inspect
    happiness.map do |end_date, user_happiness|
      total_user_happiness = user_happiness.count > 1 ? determine_user_happiness(user_happiness) : user_happiness.first[:average_happiness]
      { end_date: end_date, average_happiness: (total_user_happiness / user_happiness.count).round(1) }
    end.to_json
  end

  private

  def determine_user_happiness(user_happiness)
    user_happiness.reduce do |sum, u|
      if sum.is_a? Hash
        sum[:average_happiness] + u[:average_happiness]
      else
        sum + u[:average_happiness]
      end
    end
  end
end