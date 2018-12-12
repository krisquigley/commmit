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

  private

  def ticket_params
    params.require(:ticket).permit(:title, :estimated_effort, :url)
  end
end