# frozen_string_literal: true

class CommmitsController < ApplicationController
  def show
    @commmit = Commmit.includes(:stories, :planned_stories)
                      .order('stories.completed_at desc, stories.created_at desc')
                      .friendly.find(params[:id])

    # TODO: Only make this call when loading the modal
    story_ids = @commmit.planned_stories.map(&:story_id)
    @stories = Story.where.not(id: story_ids).where(completed_at: nil).most_recent_first
  end

  def index
    @commmits = Commmit.includes(:stories).most_recent_first
  end

  def new
    @commmit = Commmit.new
  end

  def create
    @commmit = Commmit.new(commmit_params)

    if @commmit.save
      redirect_to @commmit, notice: 'Created Commmit'
    else
      render :new
    end
  end

  def current_commmit
    @commmit = Commmit.current_commmit

    if @commmit
      redirect_to @commmit
    else
      redirect_to commmits_path
    end
  end

  protected

  def commmit_params
    params.require(:commmit).permit(:name, :length_in_days, :start_date)
  end
end
