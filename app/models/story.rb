class Story < ApplicationRecord
  acts_as_tenant(:account)

  extend FriendlyId
  friendly_id :i_want, use: :slugged

  validates :i_want, presence: true

  scope :most_recent, -> { order(created_at: :desc) }
  scope :unassigned, -> { where(commmit_id: nil) }

  belongs_to :commmit, optional: true
end
