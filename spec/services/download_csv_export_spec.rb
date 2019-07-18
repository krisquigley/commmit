require "rails_helper"
require "securerandom"

RSpec.describe DownloadCsvExport do
  describe "downloading a sprint to csv" do
    let!(:uuid) { SecureRandom.uuid }

    it "should return a string" do
      redis = Redis.new
      redis.set(uuid, "test")
      expect(DownloadCsvExport.call(uuid)).to eq "test"
    end
  end
end