# frozen_string_literal: true

class Reflection < ApplicationRecord
  acts_as_tenant :account

  belongs_to :commmit, touch: true

  validates :happiness, presence: true
  validates_inclusion_of :goal_met, in: [true, false]
end
