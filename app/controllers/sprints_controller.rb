class SprintsController < ApplicationController
  def new
    @sprint = Sprint.new
  end

  def create
    @sprint = Sprint.new(sprint_params)

    if @sprint.save
      redirect_to sprints_path, notice: "Sprint succesfully created!"
    else
      render :new
    end
  end

  def index
    @sprints = Sprint.all
  end

  def show
    @sprint = Sprint.includes(:tickets).find(params[:id])
  end

  private

  def sprint_params
    params.require(:sprint).permit(:name, :start_date, :end_date, :available_effort, :team_id)
  end
end