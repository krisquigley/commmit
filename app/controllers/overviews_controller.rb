# frozen_string_literal: true

class OverviewsController < ApplicationController
  def show
    @seven_recent_commmits = Commmit.includes(:planned_stories).kept.most_recent_first.limit(8)
  end
end
