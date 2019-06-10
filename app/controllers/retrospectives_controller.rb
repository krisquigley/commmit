class RetrospectivesController < ApplicationController
  def show
    @sprint = Sprint.includes(:retrospectives, :team).friendly.find(params[:sprint_id])
    @sprint.team.users.each do |user|
      @sprint.retrospectives.find_or_initialize_by(user: user)
    end
  end

  def create
    @sprint = Sprint.includes(:retrospectives).friendly.find(params[:sprint_id])
    @retrospective = @sprint.retrospectives.build(retrospective_params)
    
    if @retrospective.save
      redirect_to sprint_retrospective_path(@sprint)
    else
      render :new
    end
  end

  private

  def retrospective_params
    params.require(:retrospective).permit(:role_happiness, :team_happiness, :company_happiness, :feedback, :happiness_goal, :user_id)
  end
end