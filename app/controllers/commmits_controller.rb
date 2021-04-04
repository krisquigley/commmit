# frozen_string_literal: true

class CommmitsController < ApplicationController
  def show
    @commmit = Commmit.includes(:planned_stories, stories: [:tags])
                      .where('stories.discarded_at': nil)
                      .order('planned_stories.completed_at desc, planned_stories.created_at desc')
                      .find(params[:id])

    # TODO: Only make this call when loading the modal
    story_ids = @commmit.planned_stories.map(&:story_id)
    @repeatable_stories = Story.includes(:tags).repeatable.kept.completed_first
    @one_off_stories = Story.includes(:tags).incomplete.where.not(id: story_ids).one_off.kept.most_recent_first
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
    @commmit = Commmit.find(params[:id])

    return unless @commmit.discard

    redirect_back fallback_location: commmits_path,
                  notice: t('commmits.notice.archived')
  end

  def current
    # TODO: Not quite current this should not include finished commmits
    current = Commmit.kept.current_commmit

    if current.present? && !current.finished?
      params[:id] = current.id
      show

      render :show
    else
      index
      flash[:alert] = t('commmits.notice.no_commmits_today')
      render :index
    end
  end

  private

  def commmit_params
    params.require(:commmit).permit(:name, :length_in_days, :start_date)
  end
end
