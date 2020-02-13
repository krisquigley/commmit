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
    @completed_sprints = @sprints.where.not(final_velocity: nil)
    @happiness = Retrospective.retros_with_end_dates(@completed_sprints.select(:id))

    # Use sprints, loop through each sprint and get the average_happiness, if there are no retrospectives, then set the average to 0
    # raise @completed_sprints.select(:id).count.inspect
    # raise Retrospective.where(sprint_id: @completed_sprints.select(:id)).count.inspect
  end

  private

  def team_params
    params.require(:team).permit(:name, user_ids: [])
  end
end