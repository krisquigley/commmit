require 'rails_helper'

RSpec.describe "Departments", type: :feature do
  include BasicAuthHelper

  before(:each) do
    log_in
  end

  describe "viewing a department" do
    it "should list the teams"
  end

  describe "adding a department with valid data" do
    it "should create the department"
  end

  describe "adding a department with invalid data" do
    it "should not create the department"
  end
end
