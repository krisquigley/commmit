# frozen_string_literal: true

class Retrospective < ApplicationRecord
  acts_as_tenant :account

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
    average = if team_happiness
                (role_happiness + team_happiness + company_happiness) / 3
              else
                (role_happiness + company_happiness) / 2
              end

    update!(average_happiness: average)
  end
end
