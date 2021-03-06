# frozen_string_literal: true

require 'redis'

class DownloadCsvExport
  attr_reader :uuid, :redis

  def initialize(uuid)
    @redis = Redis.new(url: ENV.fetch('REDIS_URL'))
    @uuid = uuid
  end

  def self.call(uuid)
    new(uuid).call
  end

  def call
    redis.get(uuid)
  end
end
