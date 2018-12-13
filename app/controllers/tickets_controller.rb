class TicketsController < ApplicationController
  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_params)

    if @ticket.save
      redirect_to tickets_path, notice: "Ticket succesfully created!"
    else
      render :new
    end
  end

  def index
    @tickets = Ticket.all
  end

  def edit
    @ticket = Ticket.find(params[:id])
  end

  def update
    @ticket = Ticket.find(params[:id])

    @ticket.update_attributes(ticket_params)

    if @ticket.save
      redirect_to tickets_path, notice: "Ticket successfully updated!"
    else
      render :edit
    end
  end

  def manage
    @ticket = Ticket.find(params[:id])
  end

  private

  def ticket_params
    params.require(:ticket).permit(:title, :estimated_effort, :url, :actual_effort, :merged_at, :user_id)
  end
end