class DashboardController < ApplicationController
  def show
    tickets = Ticket.where.not(closed_at: nil).where.not(github_user_ids: []).select(:id, :source, :closed_at, :repository_name, 'round(estimated_effort) AS rounded_effort').group_by(&:repository_name)
    @all_tickets = group_tickets(tickets)
  end

  private
  
  def average_lead_time_in_seconds(records)
    count = records.length

    if count > 1
      total_seconds = records.inject(0) do |memo, r| 
        memo += r.closed_at - record_created_at(r)
      end
      average_seconds = total_seconds / count
    else
      average_seconds = records.first.closed_at - record_created_at(records.first)
    end
    { time: average_seconds, record_count: count }
  end

  def record_created_at(record)
    (JSON.parse(record.source)["created_at"] || JSON.parse(record.source)["issue"]["created_at"]).to_time
  end

  def group_tickets(tickets)
    tickets.map do |repo, repo_records|
      repo_tickets = repo_records.group_by(&:rounded_effort)

      average_lead_time = repo_tickets.inject({}) do |hash, (effort, records)|
        hash[effort] = average_lead_time_in_seconds(records)
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
end

# Project

# Use timeline API to pull down assigned_to timestamps and update assigned_to column in Ticket table
# Update github issue class to update assigned_to timestamp when someone is assigned to a ticket

# ticket size | average time from open to estimated / project | average time from estimated to closed / project? | average time from being assigned a user to being closed / team
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
