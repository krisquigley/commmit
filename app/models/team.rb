# frozen_string_literal: true

class Team < ApplicationRecord
  acts_as_tenant :account

  validates :name, presence: true

  has_many :users
end
