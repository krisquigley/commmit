class Retrospective < ApplicationRecord
  validates :role_happiness, :team_happiness, :company_happiness, :feedback,
            :happiness_goal, presence: true
  validates :role_happiness, :team_happiness, :company_happiness, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  belongs_to :sprint
  belongs_to :user

  def average_happiness
    if self.team_happiness
      (role_happiness + team_happiness + company_happiness) / 3
    else
      (role_happiness + company_happiness) / 2
    end
  end
end