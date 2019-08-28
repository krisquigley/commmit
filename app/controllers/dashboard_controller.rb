class DashboardController < ApplicationController
  def show
    tickets = Ticket.where.not(closed_at: nil).select(:id, :created_at, :closed_at, :repository_name, 'round(estimated_effort) AS rounded_effort').group_by(&:repository_name)
    @all_tickets = tickets.map do |repo, repo_records|
      repo_tickets = repo_records.group_by(&:rounded_effort)
      average_lead_time = repo_tickets.inject({}) do |hash, (effort, records)|
        hash[effort] = average_lead_time_in_minutes(records)
        hash
      end.sort
      { 
        repo => { 
          repo_records: average_lead_time,
          record_count: repo_records.length 
        }
      }
    end
  end
  
  def average_lead_time_in_minutes(records)
    if records.count > 1
      total_seconds = records.reduce { |memo, r| r.closed_at - r.created_at }
    else
      total_seconds = records.first.closed_at - records.first.created_at
    end
    average_seconds = total_seconds / records.length
    { average_minutes: average_seconds / 60, record_count: records.length }
  end
end

# Project

# ticket size | average time from open to estimated / project | average time from estimated to closed / project? | average time from being added to a sprint to being closed / team
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
