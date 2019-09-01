module DashboardHelper
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

  private 

  def average_lead_time_in_seconds(records)
    count = records.length

    if count > 1
      total_estimated_seconds = records.inject(0) do |memo, r| 
        memo += r.closed_at - record_created_at(r)
      end
      average_estimated_seconds = total_estimated_seconds / count

      total_assigned_seconds = records.inject(0) { |memo, r| memo += r.closed_at - r.assigned_at }
      average_assigned_seconds = total_assigned_seconds / count
    else
      average_estimated_seconds = records.first.closed_at - record_created_at(records.first)
      average_assigned_seconds = records.first.closed_at - records.first.assigned_at
    end
    { estimated_time: average_estimated_seconds, assigned_time: average_assigned_seconds, record_count: count }
  end

  def record_created_at(record)
    (JSON.parse(record.source)["created_at"] || JSON.parse(record.source)["issue"]["created_at"]).to_time
  end
end
