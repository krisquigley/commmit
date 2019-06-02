class DashboardController < ApplicationController
  def show
    @velocities = Sprint.order(end_date: :desc).group("DATE_TRUNC('week', start_date)", 'id').page(params[:page])
  end
end