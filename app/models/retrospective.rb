class Retrospective < ApplicationRecord
  # TODO: Add validations for team happiness and db constraint

  validates :role_happiness, :company_happiness, :feedback,
            :happiness_goal, presence: true
  validates :role_happiness, :company_happiness, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  belongs_to :sprint
  belongs_to :user
end