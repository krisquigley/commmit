class Webhooks::IssuesController < Webhooks::ApplicationController
  def create
    GithubIssueJob.perform_async(request.body.read)
    head :accepted
  end
end