class SprintsController < ApplicationController
  def new
    @sprint = Sprint.new
  end

  def create
    @sprint = Sprint.new(sprint_params)

    if @sprint.save
      redirect_to @sprint, notice: "Sprint succesfully created!"
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

  def manage
    @sprint = Sprint.includes(:sprint_holidays).find(params[:id])
  end

  def update
    @sprint = Sprint.find(params[:id])
    
    @sprint.update_attributes(sprint_params)
    @sprint.ticket_ids = ticket_params[:tickets]

    if @sprint.save
      redirect_to @sprint, notice: "Sprint successfully updated!"
    else
      render :manage
    end
  end

  private

  def sprint_params
    params.require(:sprint).permit(:name, :start_date, :end_date, :team_id, sprint_holidays_attributes: [:id, :days])
  end

  def ticket_params
    params.require(:sprint).permit(tickets: [])
  end
end