namespace 'github' do
  desc "retrieve all users from github for a given team"
  task import_users: :environment do
    client = Octokit::Client.new(access_token: "0109a955f493d84670d51904297507406e57e5e8")
    client.auto_paginate = true

    org_members = client.organization_members('shiftcommerce')

    org_members.each do |member|
      json_member = Oj.dump(member.to_h.merge({action: "added"}).stringify_keys)
      puts json_member.inspect
      # GithubUserJob.perform_async(json_member)
      print '#'
    end
    print 'Done'
  end

  task import_issues: :environment do
    client = Octokit::Client.new(access_token: "0109a955f493d84670d51904297507406e57e5e8")
    client.auto_paginate = true

    org_members = client.issues('shiftcommerce/shift-front-end-react')

    org_members.each do |member|
      json_member = "{\"action\":\"opened\",\"issue\":#{Oj.dump(member.to_h.deep_stringify_keys)}}"
      puts json_member.inspect
      # GithubIssueJob.perform_async(json_member)
      print '#'
    end
    print 'Done'
  end
end