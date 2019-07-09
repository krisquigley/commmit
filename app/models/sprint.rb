class Sprint < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  validates :name, :start_date, :end_date, presence: true

  belongs_to :team, optional: true
  has_many :sprint_tickets, dependent: :destroy
  has_many :retrospectives

  after_update :save_velocity, if: -> { self.closed_at && !self.final_velocity }
  after_create :save_no_of_members

  def total_estimated_effort
    sprint_tickets.map{ |s| s.estimated_effort }.reduce(:+) || 0
  end

  def velocity
    sprint_tickets.where.not(closed_at: nil).map{ |s| s.estimated_effort }.reduce(:+) || 0
  end

  def complete?
    !in_progress?
  end

  def in_progress?
    !closed_at
  end

  def goal_achieved?
    if complete?
      velocity == total_estimated_effort
    end
  end

  private

  def save_velocity
    self.update(final_velocity: self.velocity)
  end

  def save_no_of_members
    self.update(no_of_members: self.team.users.count)
  end
end
