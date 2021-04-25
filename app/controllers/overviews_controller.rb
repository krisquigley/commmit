# frozen_string_literal: true

class OverviewsController < ApplicationController
  def show
    @seven_recent_commmits = Commmit.includes(:planned_stories).kept.completed.limit(7)
  end
end
