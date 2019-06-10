class SprintTicketsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    ticket = Ticket.find_by(issue_id: params[:issue_id])
    sprint = Sprint.includes(:sprint_tickets).find(params[:sprint_id])
    position = sprint.sprint_tickets.count + 1
    sprint.sprint_tickets.create!(ticket.attributes.except("source", "id").merge(position: position))

    render json: ticket
  end

  def update
    ticket = SprintTicket.find(params[:id])
    ticket.update!(sprint_ticket_params)

    render json: ticket
  end

  def destroy
    ticket = SprintTicket.find(params[:id])
    ticket.destroy!

    render json: ticket
  end

  private

  def sprint_ticket_params
    params.require(:sprint_ticket).permit(:sprint_id, :notes, :position, :effort_spent, :issue_id)
  end
end