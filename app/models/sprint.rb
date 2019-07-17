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
    sprint_tickets.where(id: initial_ticket_ids).map{ |s| s.estimated_effort }.reduce(:+) || 0
  end

  def velocity
    sprint_tickets.where.not(closed_at: nil).map{ |s| s.estimated_effort }.reduce(:+) || 0
  end

  def complete?
    sprint_tickets.merged_tickets(initial_ticket_ids).count == initial_ticket_ids.count if !initial_ticket_ids.empty?
  end

  def finished_early?
    complete? && sprint_tickets.merged_tickets(initial_ticket_ids).last.closed_at < (finish_by + 17.hours) if finish_by
  end

  def sprint_surpassed?
    complete? && (final_velocity || velocity) > total_estimated_effort
  end

  def initial_effort_met?
    (final_velocity || velocity) == total_estimated_effort
  end

  def velocity_per_person_per_day
    final_velocity / total_man_day_minus_days_off if final_velocity
  end

  def sprint_length_in_days
    ((end_date + 1.day) - start_date) / (24 * 60 * 60)
  end

  def total_man_days
    no_of_members * sprint_length_in_days
  end

  def total_man_day_minus_days_off
    total_man_days - days_off
  end

  private

  def save_velocity
    self.update(final_velocity: self.velocity)
  end

  def save_no_of_members
    self.update(no_of_members: self.team.users.count)
  end
end
