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
  end

  private

  def department_params
    params.require(:department).permit(:name)
  end
end