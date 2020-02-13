class Retrospective < ApplicationRecord
  validates :role_happiness, :company_happiness, :feedback,
            :happiness_goal, presence: true
  validates :role_happiness, :company_happiness, 
            numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  scope :retros_with_end_dates, ->(sprint_ids) { 
    where(sprint_id: sprint_ids).joins(:sprint).map do |r|
      if r.average_happiness
        { end_date: r.sprint.end_date, average_happiness: r.average_happiness} 
      else
        { end_date: r.sprint.end_date, average_happiness: 0 } 
      end
    end.group_by {|i| i[:end_date]}.sort }

  belongs_to :sprint
  belongs_to :user

  # TODO: update user happiness graph to use average_happiness column
  after_create :determine_average_happiness

  private

  def determine_average_happiness
    if self.team_happiness
      average = (role_happiness + team_happiness + company_happiness) / 3
    else
      average = (role_happiness + company_happiness) / 2
    end

    self.update!(average_happiness: average)
  end
end