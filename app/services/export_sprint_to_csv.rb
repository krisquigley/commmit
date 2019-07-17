require 'csv'

class ExportSprintToCsv
  attr_accessor :sprint

  def initialize(sprint_id)
    self.sprint = Sprint.friendly.find(sprint_id)
  end

  def self.call(sprint_id)
    new(sprint_id).call
  end

  def call
    ::CSV.open("#{Rails.root}/tmp/#{sprint.id}.csv", "wb") do |csv|
      csv << ["title", "repository", "issue number", "state", "estimated effort",
              "opened at", "closed at", "url", "notes", "labels"]
      
      sprint.sprint_tickets.each do |ticket|
        csv << [ticket.title, ticket.repository_name, ticket.number, ticket.state, 
                ticket.estimated_effort, (JSON.parse(ticket.source)["created_at"] || JSON.parse(ticket.source)["issue"]["created_at"]),
                ticket.closed_at, ticket.url, ticket.notes, (JSON.parse(ticket.source)["labels"] || JSON.parse(ticket.source)["issue"]["labels"]).pluck("name").join(',')]
      end
    end
  end
end