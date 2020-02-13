class Retrospective < ApplicationRecord
  validates :role_happiness, :company_happiness, :feedback,
            :happiness_goal, presence: true
  validates :role_happiness, :company_happiness, 
            numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

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