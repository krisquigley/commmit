class GithubUserJob
  include Sidekiq::Worker

  def perform(payload)
    parsed_payload = GithubUser.call(payload)

    return if !parsed_payload
    user = User.find_or_initialize_by(github_user_id: parsed_payload.fetch(:github_user_id))
    user.attributes = parsed_payload
    user.save!
  end
end