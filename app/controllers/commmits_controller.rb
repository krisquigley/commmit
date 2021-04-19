# frozen_string_literal: true

class CommmitsController < ApplicationController
  def show
    @commmit = Commmit.find(params[:id])
    stories = PlannedStory.includes(story: [:values])
                          .where(commmit_id: params[:id])
                          .where('story.discarded_at': nil)
    @planned_stories = stories.todo.order(created_at: :asc)
    @completed_stories = stories.completed.order(completed_at: :asc)

    # TODO: Only make these calls when loading the modal
    story_ids = @commmit.planned_stories.map(&:story_id)
    @one_off_stories_page = current_page_from Story.includes(:values).incomplete.where.not(id: story_ids).one_off.kept.most_recent_first
    @repeatable_stories_page = current_page_from Story.includes(:values).repeatable.kept.completed_first
  end

  def index
    set_page_and_extract_portion_from Commmit.includes(:planned_stories).kept.most_recent_first
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
    current = Commmit.kept.current

    if current.present? && !current.is_a?(ActiveRecord::Relation)
      params[:id] = current.id
      show

      render :show
    else
      index
      flash.now.alert = t('commmits.notice.no_commmits_today')
      render :index
    end
  end

  private

  def commmit_params
    params.require(:commmit).permit(:name, :length_in_days, :start_date)
  end
end
