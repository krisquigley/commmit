# frozen_string_literal: true

class StoriesController < ApplicationController
  before_action :find_story, only: %i[edit update mark_as_done destroy]
  before_action :find_commmit, if: -> { params[:commmit_id] }

  def index
    @one_off_stories = Story.includes(:values).incomplete.one_off.kept.most_recent_first
    @one_off_stories_page = current_page_from @one_off_stories
    @repeatable_stories = Story.includes(:values).repeatable.kept.completed_first
    @repeatable_stories_page = current_page_from @repeatable_stories
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    @story.planned_stories.build(commmit_id: @commmit.id) if @commmit

    if @story.save
      redirect_back fallback_location: new_story_path, notice: t('stories.notice.created')
    else
      render :new
    end
  end

  def edit; end

  def update
    story_params[:value_ids]&.reject!(&:empty?)

    if @story.update(story_params)
      redirect_to stories_path, notice: t('stories.notice.updated')
    else
      render :edit
    end
  end

  def destroy
    return unless @story.discard

    redirect_back fallback_location: stories_path,
                  notice: t('stories.notice.archived')
  end

  private

  def find_commmit
    @commmit = Commmit.find(params[:commmit_id])
  end

  def find_story
    @story = Story.includes(:values).find(params[:id])
  end

  def story_params
    params.require(:story).permit(:goal, :reason, :notes, :repeatable, :automatically_add, value_ids: [])
  end
end
