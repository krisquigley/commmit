class SprintTicketsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    ticket = Ticket.find_by(issue_id: params[:issue_id])
    sprint = Sprint.find(params[:sprint_id])
    sprint.sprint_tickets.create!(ticket.attributes.except("source", "id"))

    render json: ticket
  end

  def update
    ticket = SprintTicket.find_by(issue_id: params[:id], sprint_id: params[:sprint_id])
    ticket.update!(sprint_ticket_params)

    render json: ticket
  end

  def destroy
    ticket = SprintTicket.find_by(sprint_id: params[:sprint_id], issue_id: params[:id])
    ticket.destroy!

    render json: ticket
  end

  private

  def sprint_ticket_params
    params.require(:sprint_ticket).permit(:sprint_id, :notes, :actual_effort, :issue_id, :estimated_effort_override)
  end
end