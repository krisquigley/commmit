require "rails_helper"

RSpec.describe GithubIssue do
  describe "when new issues are created with no estimations" do
    let!(:subject) do
      new_issue_payload = file_fixture("opened_issue_payload.json").read
      GithubIssue.call(new_issue_payload)
    end

    let(:parsed_new_issue) do
      {
        repository_name: "krisquigley/sprintable",
        number: 2,
        title: "new issue",
        state: "open",
        estimated_effort: nil,
        issue_id: 406911947,
        closed_at: nil
      }
    end

    it "should return nothing" do
      expect(subject).to eq(nil)
    end
  end

  describe "when new issues are created with an estimations" do
    let!(:subject) do
      new_issue_payload = file_fixture("opened_issue_with_estimation_payload.json").read
      GithubIssue.call(new_issue_payload)
    end

    let(:parsed_new_issue) do
      {
        repository_name: "krisquigley/sprintable",
        number: 2,
        title: "[2] new issue",
        state: "open",
        estimated_effort: 2,
        issue_id: 406911947,
        closed_at: nil
      }
    end

    it "should return nothing" do
      expect(subject).to eq(parsed_new_issue)
    end
  end

  describe "when issues are edited" do
    let!(:subject) do
      edited_issue_payload = file_fixture("edited_issue_payload.json").read
      GithubIssue.call(edited_issue_payload)
    end

    let(:parsed_edited_issue) do
      {
        repository_name: "krisquigley/sprintable",
        number: 2,
        title: "[2] new issue",
        state: "open",
        estimated_effort: 2,
        issue_id: 406911947,
        closed_at: nil
      }
    end

    it "should parse the payload into a hash" do
      expect(subject).to eq(parsed_edited_issue)
    end
  end

  describe "when issues are closed" do
    let!(:subject) do
      closed_issue_payload = file_fixture("closed_issue_payload.json").read
      GithubIssue.call(closed_issue_payload)
    end

    let(:parsed_closed_issue) do
      {
        repository_name: "krisquigley/sprintable",
        number: 2,
        title: "[2] new issue",
        state: "closed",
        estimated_effort: 2,
        issue_id: 406911947,
        closed_at: "2019-02-05T18:26:06Z"
      }
    end

    it "should parse the payload into a hash" do
      expect(subject).to eq(parsed_closed_issue)
    end
  end

  describe "when issues are reopened" do
    let!(:subject) do
      reopened_issue_payload = file_fixture("reopened_issue_payload.json").read
      GithubIssue.call(reopened_issue_payload)
    end

    let(:parsed_reopened_issue) do
      {
        repository_name: "krisquigley/sprintable",
        number: 2,
        title: "[2] new issue",
        state: "open",
        estimated_effort: 2,
        issue_id: 406911947,
        closed_at: nil
      }
    end

    it "should parse the payload into a hash" do
      expect(subject).to eq(parsed_reopened_issue)
    end
  end

  describe "when issues are labelled" do
    let!(:subject) do
      labelled_issue_payload = file_fixture("labelled_issue_payload.json").read
      GithubIssue.call(labelled_issue_payload)
    end

    it "should parse the payload into a hash" do
      expect(subject).to eq(nil)
    end
  end
end