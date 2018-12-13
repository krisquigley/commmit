class Sprint < ApplicationRecord
  validates :name, :start_date, :end_date, :team_id, presence: true

  has_many :tickets
  has_many :sprint_holidays
  belongs_to :team

  accepts_nested_attributes_for :sprint_holidays, :tickets


  before_create :calculate_available_effort
  after_create :create_sprint_holidays

  def available_effort_after_review_time
    ((available_effort - self.sprint_holidays.pluck(:days).reduce(:+))* 0.8).round
  end

  def effort_accounted_for
    available_effort_after_review_time - total_estimated_effort
  end

  def total_estimated_effort
    tickets.pluck(:estimated_effort).reduce(:+) || 0
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