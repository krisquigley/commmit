class ExportSprintToCsvJob
  include Sidekiq::Worker

  def perform(sprint_id)
    ExportSprintToCsv.call(sprint_id)
  end
end