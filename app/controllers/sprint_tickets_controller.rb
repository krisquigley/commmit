class SprintTicketsController < ApplicationController
  def index
    @tickets = SprintTicket.order(updated_at: :desc).page(params[:page])
  end

  def edit
    @ticket = SprintTicket.find(params[:id])
  end

  def update
    @ticket = SprintTicket.find(params[:id])

    @ticket.update_attributes(sprint_ticket_params)

    if @ticket.save
      redirect_to sprint_tickets_path, notice: "Ticket successfully updated!"
    else
      render :edit
    end
  end

  private

  def sprint_ticket_params
    params.require(:sprint_ticket).permit(:actual_effort)
  end
end