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

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])

    if @team.update(team_params)
      redirect_to teams_path, notice: "Team succesfully updated!"
    else
      render :new
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, user_ids: [])
  end
end