# frozen_string_literal: true

class Story < ApplicationRecord
  acts_as_tenant(:account)

  extend FriendlyId
  friendly_id :i_want, use: :slugged

  validates :i_want, presence: true

  scope :most_recent_first, -> { order(created_at: :desc) }
  scope :unassigned, -> { where(commmit_id: nil) }
  scope :todo, -> { where(completed_at: nil) }

  belongs_to :commmit, optional: true, counter_cache: true

  def completed?
    completed_at.present?
  end
end
