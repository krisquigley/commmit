# frozen_string_literal: true

class Commmit < ApplicationRecord
  acts_as_tenant :account

  extend FriendlyId
  friendly_id :name, use: :slugged

  scope :most_recent, -> { order(created_at: :desc) }

  validates :name, :length_in_days, presence: true
  validates :length_in_days, numericality: { only_integer: true, greater_than: 0 }
end
