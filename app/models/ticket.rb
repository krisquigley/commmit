class Ticket < ApplicationRecord
  validates :title, :estimated_effort, :url, presence: true

  belongs_to :sprint, optional: true
  belongs_to :user, optional: true
end