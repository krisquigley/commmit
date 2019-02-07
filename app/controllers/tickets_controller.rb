class TicketsController < ApplicationController
  protect_from_forgery except: :create

  def create
    GithubIssueJob.perform_async(request.body.read)
    head :accepted
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
    params.require(:ticket).permit(:actual_effort)
  end

  def webhook_params
    params.permit!
  end
end