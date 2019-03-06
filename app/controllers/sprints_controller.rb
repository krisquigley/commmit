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
    @sprints = Sprint.order(end_date: :desc)
  end

  def show
    @sprint = Sprint.includes(:sprint_tickets).order('sprint_tickets.position asc').find(params[:id])
  end

  def manage
    @sprint = Sprint.includes(:sprint_holidays, :sprint_tickets).find(params[:id])
    @sprint_tickets = @sprint.sprint_tickets.order(position: :asc)
    tickets = Ticket.where.not(issue_id: @sprint_tickets.pluck(:issue_id)).order(updated_at: :desc).page(params[:page])
    
    if params[:repository_name] && !params[:repository_name].empty?
      tickets = tickets.where(repository_name: params[:repository_name])
    elsif params[:search] && !params[:search].empty?
      tickets = tickets.where('lower(title) LIKE ?', "%#{params[:search].downcase}%")
    end

    @tickets = tickets 
  end

  def update
    @sprint = Sprint.find(params[:id])
    
    @sprint.update_attributes(sprint_params)
    
    if !ticket_params.empty?
      tickets = SprintTicket.find(ticket_params[:sprint_tickets])
      @sprint.sprint_tickets.create(tickets.first.attributes.except("source"))
    end

    if @sprint.save
      redirect_to @sprint, notice: "Sprint successfully updated!"
    else
      render :manage
    end
  end

  def close
    if Sprint.find(params[:id]).update(closed_at: Time.now)
      redirect_to sprints_path
    else
      render :show
    end
  end

  private

  def sprint_params
    params.require(:sprint).permit(:name, :start_date, :end_date, :team_id, sprint_holidays_attributes: [:id, :days])
  end

  def ticket_params
    params.require(:sprint).permit(sprint_tickets: [])
  end
end