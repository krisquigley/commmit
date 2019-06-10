require 'rails_helper'

RSpec.describe "Teams", type: :feature do
  include BasicAuthHelper

  before(:each) do
    log_in
  end

  describe "viewing a team" do
    it "should list the sprints"
  end

  describe "adding a team with valid data" do
    it "should create the team"
  end

  describe "adding a team with invalid data" do
    it "should not create the team"
  end
end
