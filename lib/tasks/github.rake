namespace 'github' do
  desc "retrieve all users from github for a given team"
  task import_users: :environment do
    client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_ACCESS_TOKEN'))
    client.auto_paginate = true

    org_members = client.organization_members('shiftcommerce')

    org_members.each do |member|
      json_member = Oj.dump(member.to_h.merge({action: "added"}).stringify_keys)
      GithubUserJob.perform_async(json_member)
      print '#'
    end
    print 'Done'
  end

  task :import_issues, [:repo] => :environment do |task, args|
    client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_ACCESS_TOKEN'))
    client.auto_paginate = true

    issues = client.issues(args[:repo] , query: { state: "open"})

    issues.each do |issue|
      # Update issue to take URL instead.  determine the repo from the url.
      json_issue = Oj.dump(issue.to_h.merge({action: "opened"}).stringify_keys)
      GithubIssueJob.perform_async(json_issue)
      print '#'
    end
    print 'Done'
  end

  task :import_assigned => :environment do |task, args|
    tickets = Ticket.where(assigned_at: nil)

    client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_ACCESS_TOKEN'))
    client.auto_paginate = true

    tickets.each do |ticket|
      issue = client.issue_timeline(ticket.repository_name, ticket.number).find do |issue|
        issue.event == "assigned"
      end
      ticket.update(assigned_at: issue.created_at) if issue
      print 'Done'
    end
  end
end