class Story < ApplicationRecord
  acts_as_tenant(:account)

  extend FriendlyId
  friendly_id :i_want_to, use: :slugged

  validates :i_want_to, presence: true
end
