require 'redis'

class ExportSprintToCsvJob
  include Sidekiq::Worker

  def perform(sprint_id, uuid)
    csv_string = ExportSprintToCsv.call(sprint_id)
    redis = Redis.new(url: ENV.fetch('REDIS_URL'))
    redis.set(uuid, csv_string)
  end
end