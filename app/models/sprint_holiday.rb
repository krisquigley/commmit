class SprintHoliday < ApplicationRecord
  validates :sprint_id, :user_id, :days, presence: true

  belongs_to :sprint
  belongs_to :user
end