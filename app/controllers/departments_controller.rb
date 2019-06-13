class DepartmentsController < ApplicationController
  def index
    @departments = Department.order(name: :asc)
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)

    if @department.save
      redirect_to @department, notice: "Department succesfully created!"
    else
      render :new
    end
  end

  def show
    @department = Department.includes(:teams).friendly.find(params[:id])
    @sprints = Sprint.includes(:team).where(team_id: @department.teams).where.not(final_velocity: nil)
               .select(:final_velocity, 'team.id').order(created_at: :desc).limit(10).reverse.to_json
  end

  private

  def department_params
    params.require(:department).permit(:name)
  end
end