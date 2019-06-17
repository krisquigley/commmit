class SprintTicketsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    ticket = Ticket.find_by(issue_id: params[:issue_id])
    sprint = Sprint.includes(:sprint_tickets).find(params[:sprint_id])
    position = sprint.sprint_tickets.count + 1
    sprint_ticket = sprint.sprint_tickets.create!(ticket.attributes.except("source", "id").merge(position: position))

    render json: sprint_ticket
  end

  def update
    sprint_ticket = SprintTicket.find(params[:id])
    sprint_ticket.update!(sprint_ticket_params)

    render json: sprint_ticket
  end

  def destroy
    sprint_ticket = SprintTicket.find(params[:id])
    sprint_ticket.destroy!

    render json: sprint_ticket
  end

  private

  def sprint_ticket_params
    params.require(:sprint_ticket).permit(:sprint_id, :notes, :position, :effort_spent, :issue_id)
  end
end