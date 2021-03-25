# frozen_string_literal: true

class CommmitsController < ApplicationController
  def show
    @commmit = Commmit.includes(:stories, :planned_stories)
                      .where('stories.discarded_at': nil)
                      .order('planned_stories.completed_at desc, planned_stories.created_at desc')
                      .friendly.find(params[:id])

    # TODO: Only make this call when loading the modal
    story_ids = @commmit.planned_stories.map(&:story_id)
    @repeatable_stories = Story.where(completed_at: nil).where(repeatable: true).kept.most_recent_first
    @one_off_stories = Story.where.not(id: story_ids).where(completed_at: nil).where(repeatable: false).kept.most_recent_first
  end

  def index
    @commmits = Commmit.includes(:stories).kept.most_recent_first
  end

  def new
    @commmit = Commmit.new
  end

  def create
    @commmit = Commmit.new(commmit_params)

    if @commmit.save
      redirect_to @commmit, notice: t('commmits.notice.created')
    else
      render :new
    end
  end

  def destroy
    @commmit = Commmit.friendly.find(params[:id])

    return unless @commmit.discard

    redirect_back fallback_location: commmits_path,
                  notice: t('commmits.notice.destroyed')
  end

  def current_commmit
    commmit = Commmit.kept.current_commmit

    if commmit.present?
      redirect_to commmit
    else
      redirect_to commmits_path
    end
  end

  private

  def commmit_params
    params.require(:commmit).permit(:name, :length_in_days, :start_date)
  end
end
