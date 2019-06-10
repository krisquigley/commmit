class SprintsController < ApplicationController
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
    @yesterdays_weather = Sprint.where.not(id: @sprint.id).order(created_at: :desc).limit(3).pluck(:final_velocity)
    @tickets = Ticket.where.not(issue_id: @sprint_tickets.pluck(:issue_id)).order(updated_at: :desc).page(params[:page])
    
    if params[:repository_name] && !params[:repository_name].empty?
      @tickets = @tickets.where(repository_name: params[:repository_name])
    elsif params[:search] && !params[:search].empty?
      @tickets = @tickets.where('lower(title) || number LIKE ?', "%#{params[:search].downcase}%")
    end
  end

  def update
    @sprint = Sprint.friendly.find(params[:id])
    @sprint.update_attributes(sprint_params)
    
    if @sprint.save
      if params["sprint"]["return_to"] == 'retrospective'
        redirect_to sprint_retrospective_path(@sprint), notice: "Sprint successfully updated!"
      else
        redirect_to manage_sprint_path(@sprint), notice: "Sprint successfully updated!"
      end
    else
      render :manage
    end
  end

  def close
    if Sprint.friendly.find(params[:id]).update(closed_at: Time.now)
      redirect_to sprint_path(params[:id])
    else
      render :show
    end
  end

  private

  def sprint_params
    params.require(:sprint).permit(:name, :start_date, :end_date, :what_went_well, 
                                   :what_could_be_better, :what_one_thing_to_work_on)
  end
end