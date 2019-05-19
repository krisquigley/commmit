require "rails_helper"

RSpec.describe "Retro Feedback", type: :feature do
  include BasicAuthHelper
  
  before(:each) do
    log_in
  end

  describe "viewing sprint feedback for a sprint" do
    it "should show happiness values"
    
    it "should show feedback"
  end

  context "adding feedback to a sprint" do
    describe "with valid data" do
      it "should get added"
    end

    describe "with invalid data" do
      it "should not get added"
    end
  end
end