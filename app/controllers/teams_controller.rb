class TeamsController < ApplicationController
  def new
    @department = Department.friendly.find(params[:department_id])
    @team = @department.teams.build
  end

  def create
    @department = Department.friendly.find(params[:department_id])
    @team = @department.teams.build(team_params)

    if @team.save
      redirect_to @department
    else
      render :new
    end
  end

  def show
    @team = Team.includes(:sprints).friendly.find(params[:id])
    @sprints = @team.sprints.page(params[:page])
  end

  private

  def team_params
    params.require(:team).permit(:name, user_ids: [])
  end
end