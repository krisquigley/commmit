class TeamsController < ApplicationController
  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to teams_path, notice: "Team succesfully created!"
    else
      render :new
    end
  end

  def index
    @teams = Team.all
  end

  def show
    @team = Team.includes(:users).find(params[:id])
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end