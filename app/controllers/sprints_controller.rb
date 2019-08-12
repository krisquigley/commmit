class SprintsController < ApplicationController
  protect_from_forgery except: [:export_csv, :download_csv]

  def new
    @team = Team.friendly.find(params[:team_id])
    @sprint = @team.sprints.build
  end

  def create
    @team = Team.friendly.find(params[:team_id])
    @sprint = @team.sprints.build(sprint_params)

    if @sprint.save
      redirect_to @sprint, notice: "Sprint succesfully created!"
    else
      render :new
    end
  end

  def show
    @sprint = Sprint.includes(:sprint_tickets).order('sprint_tickets.position asc').friendly.find(params[:id])
  end

  def manage
    @sprint = Sprint.includes(:sprint_tickets).friendly.find(params[:id])
    @sprint_tickets = @sprint.sprint_tickets.order(position: :asc)
    @yesterdays_weather = @sprint.team.yesterdays_weather
    @tickets = Ticket.where.not(issue_id: @sprint_tickets.pluck(:issue_id)).where(closed_at: nil).order(updated_at: :desc).page(params[:page])
    @recent_velocity_per_person_per_day = @sprint.team.sprints.where.not(final_velocity: nil).order(end_date: :desc).limit(3)
    
    if (params[:search] && !params[:search].empty?) && (params[:repository_name] && !params[:repository_name].empty?)
      @tickets = @tickets.search_by_title_or_issue_number_and_filter(params[:search], params[:repository_name])
    elsif params[:repository_name] && !params[:repository_name].empty?
      @tickets = @tickets.filter_by_repository_name(params[:repository_name])
    elsif params[:search] && !params[:search].empty?
      @tickets = @tickets.search_by_title_or_issue_number(params[:search])
    end
  end

  def update
    @sprint = Sprint.friendly.find(params[:id])
    @sprint.update_attributes(sprint_params)
    
    if @sprint.save
      if params["sprint"]["return_to"] == 'retrospective'
        redirect_to sprint_retrospective_path(@sprint), notice: "Sprint successfully updated!"
      elsif params["commit"] == "Lock & Load"
        @sprint.update(initial_ticket_ids: @sprint.sprint_tickets.pluck(:id))
        redirect_to sprint_path(@sprint), notice: "Sprint Locked and Loaded!"
      elsif params["commit"] == "Close Sprint"
        @sprint.update(days_off: sprint_params[:days_off], closed_at: Time.now)
        redirect_to sprint_path(@sprint), notice: "Sprint Closed!"
      else
        redirect_to manage_sprint_path(@sprint), notice: "Sprint successfully updated!"
      end
    else
      render :manage
    end
  end

  def export_csv
    if ExportSprintToCsvJob.perform_async(params[:id], params[:uuid])
      render json: {}, status: :ok
    else
      render json: { errors: "failed" }, status: 500
    end 
  end

  def download_csv
    if DownloadCsvExport.call(params[:uuid])
      send_data DownloadCsvExport.call(params[:uuid]), filename: "#{params[:uuid]}.csv"
    else
      render json: {}, status: :not_found
    end
  end

  private

  def sprint_params
    params.require(:sprint).permit(:name, :start_date, :end_date, :what_went_well, 
                                   :what_could_be_better, :what_one_thing_to_work_on,
                                   :days_off, :finish_by)
  end
end