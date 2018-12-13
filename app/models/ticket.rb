class Ticket < ApplicationRecord
  validates :title, :estimated_effort, :url, presence: true

  belongs_to :sprint, optional: true
  belongs_to :user, optional: true

  def actual_effort
    read_attribute(:actual_effort) || "N/A"
  end

  def merged_at
    read_attribute(:merged_at) || 'Unmerged'
  end
end