class Sprint < ApplicationRecord
  validates :name, :start_date, :end_date, :team_id, presence: true

  has_many :sprint_tickets
  has_many :sprint_holidays
  belongs_to :team

  accepts_nested_attributes_for :sprint_holidays

  before_create :calculate_available_effort
  after_create :create_sprint_holidays

  def available_effort_after_review_time
    ((available_effort - self.sprint_holidays.pluck(:days).reduce(:+))* 0.8).round
  end

  def total_estimated_effort
    sprint_tickets.pluck(:estimated_effort).reduce(:+) || 0
  end

  def effort_remaining
    available_effort_after_review_time - total_estimated_effort
  end

  def effort_to_date
    merged_tickets = sprint_tickets.where.not(closed_at: nil).order(closed_at: :asc)
    effort = []
    day = start_date.to_date
    current_effort = total_estimated_effort

    while day <= Date.today && day <= end_date do
      ticket = merged_tickets.find do |merged_ticket|
        day == merged_ticket.closed_at.to_date
      end

      current_effort = current_effort - ticket.estimated_effort if ticket

      effort.push(current_effort)
      day = day + 1.day
    end

    return effort.to_json
  end

  def in_progress?
    Date.today <= end_date 
  end

  def status
    in_progress? ? 'In Progress' : 'Finished'
  end

  private

  def calculate_available_effort
    users = self.team.users.count

    number_of_work_days = 0
    day = self.start_date

    while day <= self.end_date do
      if day.on_weekend?
        day = day.next_weekday
        next
      end
      number_of_work_days += 1
      day = day.next_weekday
    end
    self.available_effort = number_of_work_days * users
  end

  def create_sprint_holidays
    self.team.users.each do |user|
      self.sprint_holidays.create(user: user)
    end
  end
end