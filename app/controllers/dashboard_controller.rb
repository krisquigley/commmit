class DashboardController < ApplicationController
  def show
    @tickets = Ticket.where.not(closed_at: nil).where.not(assigned_at: nil).select(:id, :source, :assigned_at, :closed_at, :repository_name, 'round(estimated_effort) AS rounded_effort').group_by(&:repository_name)
  end
end

# Project

# Use timeline API to pull down assigned_to timestamps and update assigned_at column in Ticket table
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
