require 'rails_helper'

RSpec.describe Github::User do
  describe "adding a new user" do
    let(:new_user_payload) { file_fixture("new_user_payload.json").read }
    subject do 
      Github::User.call(new_user_payload)
    end

    let(:parsed_payload) do
      {
        name: "octocat",
        github_user_id: 583231,
        source: Oj.dump(Oj.load(new_user_payload)["member"])
      }
    end

    it "should return the parsed payload" do
      expect(subject).to eq(parsed_payload)
    end
  end

  describe "updating a user" do
    let(:edited_user_payload) { file_fixture("edited_user_payload.json").read }
    subject do 
      Github::User.call(edited_user_payload)
    end

    let(:parsed_payload) do
      {
        name: "octodog",
        github_user_id: 583231,
        source: Oj.dump(Oj.load(edited_user_payload)["member"])
      }
    end

    it "should return the parsed payload" do
      expect(subject).to eq(parsed_payload)
    end
  end

  describe "receiving a delete payload" do
    let(:deleted_user_payload) { file_fixture("deleted_user_payload.json").read }
    subject do 
      Github::User.call(deleted_user_payload)
    end

    it "should return nil" do
      expect(subject).to eq(nil)
    end
  end

end