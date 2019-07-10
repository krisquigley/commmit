module TeamsHelper
  def velocity(sprints)
    sprints.select(:final_velocity, :end_date).reverse.to_json
  end

  def happiness_values(happiness)
    happiness.map do |end_date, user_happiness|
      total_user_happiness = user_happiness.count > 1 ? determine_user_happiness(user_happiness) : user_happiness.first[:average_happiness]
      { end_date: end_date, average_happiness: (total_user_happiness / user_happiness.count).round(1) }
    end.to_json
  end

  def no_of_members_per_sprint(sprints)
    sprints.reverse.map(&:no_of_members).to_json
  end

  def velocity_per_person_per_day_per_sprint(sprints)
    sprints.reverse.map { |s| s.velocity_per_person_per_day.round(2) }.to_json
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