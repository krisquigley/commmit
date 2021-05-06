# frozen_string_literal: true

class PlannedStoriesController < ApplicationController
  before_action :set_commmit, only: %i[index create mark_as_done mark_as_done mark]
  before_action :set_planned_stories, only: %i[create mark_as_done mark_as_done mark]
  before_action :set_completed_stories, only: %i[create mark_as_done mark_as_done mark]

  def index
    if params[:commmit_id] == 'current' && !@commmit
      # Redirect to commmits#index if no currently active commmits
      redirect_to commmits_path
    else
      set_stories
      set_planned_stories
      set_completed_stories
      set_story
    end
  end

  def show
    flash.now.notice = t('commmits.planned_stories.notice.focus_mode')
    @planned_story = PlannedStory.includes(:commmit, :story, story: :values).find(params[:id])
  end

  def create
    @planned_story = @commmit.planned_stories.create(story_id: params[:story_id])

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to commmit_planned_stories_path(@commmit), notice: t('stories.notice.added')
      end
    end
  end

  def mark_as_done
    @planned_story = PlannedStory.find(params[:planned_story_id])
    @planned_story.update(completed_at: Time.now)

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to commmit_planned_stories_path(@planned_story.commmit), notice: t('stories.notice.done')
      end
    end
  end

  def mark_as_not_done
    @planned_story = PlannedStory.find(params[:planned_story_id])
    @planned_story.update(completed_at: nil)

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to commmit_planned_stories_path(@planned_story.commmit), notice: t('stories.notice.not_done')
      end
    end
  end

  def destroy
    @planned_story = PlannedStory.find(params[:id])
    redirect = commmit_planned_stories_path(@planned_story.commmit)

    return unless @planned_story.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to redirect, notice: t('stories.notice.removed') }
    end
  end

  private

  def planned_story_params
    params.require(:planned_story).permit(:commmit_id, :story_id, :completed_at, :planned_story_id)
  end

  def all_planned_stories
    @all_planned_stories ||= PlannedStory.includes(story: [:values])
                                         .where(commmit_id: @commmit.id)
  end

  def set_planned_stories
    @planned_stories = all_planned_stories.todo.order(created_at: :asc)
  end

  def set_completed_stories
    @completed_stories = all_planned_stories.completed.order(completed_at: :asc)
  end

  def set_commmit
    commmit = Commmit.current

    @commmit = if params[:commmit_id] == 'current'
                 commmit.first if commmit.size.positive?
               else
                 Commmit.find(params[:commmit_id] || planned_story_params[:commmit_id])
               end
  end

  def set_story
    @story = Story.new
  end

  def set_stories
    # TODO: Only make these calls when loading the modal
    story_ids = all_planned_stories.map(&:story_id)
    @one_off_stories_page = current_page_from Story.includes(:values)
                                                   .incomplete
                                                   .where.not(id: story_ids)
                                                   .one_off
                                                   .kept
                                                   .most_recent_first

    @repeatable_stories_page = current_page_from Story.includes(:values)
                                                      .repeatable
                                                      .kept
                                                      .completed_first
  end
end
