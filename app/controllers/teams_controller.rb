class TeamsController < ApplicationController
  def index
    @teams = Team.order(name: :asc)
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to @team
    else
      render :new
    end
  end

  def show
    @team = Team.includes(:sprints).friendly.find(params[:id])
    @sprints = @team.sprints.order(end_date: :desc).page(params[:page])
    @completed_sprints = @sprints.includes(:retrospectives).where.not(final_velocity: nil)
  end

  private

  def team_params
    params.require(:team).permit(:name, user_ids: [])
  end
end