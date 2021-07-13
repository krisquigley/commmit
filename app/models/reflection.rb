# frozen_string_literal: true

class Reflection < ApplicationRecord
  acts_as_tenant :account

  belongs_to :commmit, touch: true

  validates :happiness, presence: true
  validates_inclusion_of :goal_met, in: [true, false]

  before_create :goal_met?

  private

  def goal_met?
    commmit_goal = commmit.commmit_goal

    self.goal_met = commmit_goal.completed? if commmit_goal.present?
  end
end
