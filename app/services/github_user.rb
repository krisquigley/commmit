class GithubUser
  attr_accessor :parsed_payload

  ACTIONS = [
    "added",
    "edited"
  ]
  
  def self.call(payload)
    new(payload).call
  end

  def initialize(payload)
    self.parsed_payload = Oj.load(payload, symbol_keys: true)
  end

  def call
    return if !ACTIONS.include?(parsed_payload.fetch(:action))
    attributes
  end

  private

  def attributes
    {
      name: parsed_payload.fetch(:member).fetch(:login),
      github_user_id: parsed_payload.fetch(:member).fetch(:id)
    }
  end
end