class Retrospective < ApplicationRecord
  validates :role_happiness, :team_happiness, :company_happiness, :feedback,
            :happiness_goal, presence: true
  validates :role_happiness, :team_happiness, :company_happiness, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  belongs_to :sprint
  belongs_to :user
end