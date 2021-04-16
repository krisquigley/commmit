# frozen_string_literal: true

module Github
  class Base
    attr_accessor :parsed_payload, :payload

    def initialize(payload)
      self.payload = payload
      self.parsed_payload = Oj.load(payload, symbol_keys: true)
    end

    def self.call(payload)
      new(payload).call
    end

    def call
      return if !actions.include?(parsed_payload[:action]) || validations

      attributes
    end

    private

    def actions
      raise NotImpementedError, 'You must implement an actions method'
    end

    def validations; end

    def attributes
      raise NotImpementedError, 'You must implement an attributes method'
    end

    class NotImpementedError < StandardError; end
  end
end
