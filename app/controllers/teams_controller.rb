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
    @sprints = @team.sprints.order(end_date: :desc).page(params[:page])
    @velocity = @sprints.where.not(final_velocity: nil).select(:end_date, :final_velocity).reverse.to_json
    @happiness = Retrospective.where(sprint_id: @sprints.select(:id))
  end

  private

  def team_params
    params.require(:team).permit(:name, user_ids: [])
  end
end