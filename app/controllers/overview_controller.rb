# frozen_string_literal: true

class OverviewController < ApplicationController
  def show
    @seven_recent_commmits = Commmit.includes(:planned_stories, :reflection, planned_stories: [{ story: [:values] }]).kept.completed.limit(7)
    @values = Value.kept
  end
end
