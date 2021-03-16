# frozen_string_literal: true

class Tag < ApplicationRecord
  acts_as_tenant :account

  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :account

  validates :name, :color, presence: true

  has_and_belongs_to_many :commmits
  has_and_belongs_to_many :stories
end
