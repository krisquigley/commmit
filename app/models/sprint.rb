class Sprint < ApplicationRecord
  validates :name, :start_date, :end_date, :team_id, :available_effort, presence: true

  has_many :tickets
  belongs_to :team
end