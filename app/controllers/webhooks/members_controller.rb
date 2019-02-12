class Webhooks::MembersController < Webhooks::ApplicationController
  def create
    GithubUserJob.perform_async(request.body.read)
    head :accepted
  end
end