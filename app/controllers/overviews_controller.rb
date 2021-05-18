# frozen_string_literal: true

class OverviewsController < ApplicationController
  def show
    @seven_recent_commmits = Commmit.includes(:planned_stories, :reflection).kept.completed.limit(7)
  end
end
