module TeamsHelper
  def happiness_values(happiness)
    happiness = happiness.map do |retro| 
      { user_id: retro.user_id, average_happiness: retro.average_happiness }
    end.group_by { |i| i[:user_id] }
    
    unless happiness.empty?
      no_of_sprints = happiness.first[1].count
      no_of_users = happiness.keys.count
      happiness_values = []

      (0...no_of_sprints).each do |index|
        average_retro_happiness = 0
        happiness.each do |key, user_happiness|
          average_retro_happiness += user_happiness[index][:average_happiness]
        end
        happiness_values << (average_retro_happiness / no_of_users).round(1)
      end
      happiness_values.to_json
    end
  end
end