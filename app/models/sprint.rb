class Sprint < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  validates :name, :start_date, :end_date, :users, presence: true

  has_many :sprint_tickets, dependent: :destroy
  has_many :retrospectives
  has_and_belongs_to_many :users

  def total_estimated_effort
    sprint_tickets.map{ |s| s.estimated_effort }.reduce(:+) || 0
  end

  def velocity
    sprint_tickets.where.not(closed_at: nil).map{ |s| s.estimated_effort }.reduce(:+) || 0
  end

  def effort_to_date
    merged_tickets = sprint_tickets.where.not(closed_at: nil).order(closed_at: :asc)
    effort = []
    day = start_date.to_date
    current_effort = total_estimated_effort

    while day <= Date.today && day <= end_date do
      tickets = merged_tickets.find_all do |merged_ticket|
        day == merged_ticket.closed_at.to_date
      end

      current_effort = current_effort - tickets.map{ |s| s.estimated_effort }.reduce(:+) if !tickets.empty?

      effort.push(current_effort)
      day = day + 1.day
    end

    effort.to_json
  end

  def complete?
    !in_progress?
  end

  def in_progress?
    (Date.today <= end_date && !closed_at)
  end

  def status
    if in_progress?
      'In Progress'
    elsif goal_achieved? 
      'Completed'
    elsif !goal_achieved?
      'Sprint Ended'
    end
  end

  def goal_achieved?
    if complete?
      velocity == total_estimated_effort
    end
  end
end
