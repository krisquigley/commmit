class SprintTicketsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    ticket = Ticket.find_by(issue_id: params[:issue_id])
    sprint = Sprint.find(params[:sprint_id])
    sprint.sprint_tickets.create(ticket.attributes.except("source"))

    render json: ticket
  end

  def destroy
    ticket = SprintTicket.find_by(sprint_id: params[:sprint_id], issue_id: params[:id])
    ticket.destroy

    render json: ticket
  end
end