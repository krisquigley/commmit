class Webhooks::MembersController < Webhooks::ApplicationController
  def create
    # Ensure UTF8 characters are encoded properly
    params = request.body.read.encode!("UTF-8", invalid: :replace, undef: :replace).force_encoding("utf-8")

    GithubUserJob.perform_async(params)
    head :accepted
  end
end