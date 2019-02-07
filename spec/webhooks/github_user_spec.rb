require 'rails_helper'

RSpec.describe GithubUser do
  describe "adding a new user" do
    subject do 
      new_user_payload = file_fixture("new_user_payload.json").read
      GithubUser.call(new_user_payload)
    end

    let(:parsed_payload) do
      {
        name: "octocat",
        github_user_id: 583231
      }
    end

    it "should return the parsed payload" do
      expect(subject).to eq(parsed_payload)
    end
  end

  describe "updating a user" do
    subject do 
      edited_user_payload = file_fixture("edited_user_payload.json").read
      GithubUser.call(edited_user_payload)
    end

    let(:parsed_payload) do
      {
        name: "octodog",
        github_user_id: 583231
      }
    end

    it "should return the parsed payload" do
      expect(subject).to eq(parsed_payload)
    end
  end

  describe "receiving a delete payload" do
    subject do 
      deleted_user_payload = file_fixture("deleted_user_payload.json").read
      GithubUser.call(deleted_user_payload)
    end

    it "should return nil" do
      expect(subject).to eq(nil)
    end
  end

end