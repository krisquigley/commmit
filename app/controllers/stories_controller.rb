# frozen_string_literal: true

class StoriesController < ApplicationController
  before_action :find_story, only: %i[show edit update mark_as_done destroy]
  before_action :find_commmit, if: -> { params[:commmit_id] }

  def index; end

  def one_off
    @one_off_stories = Story.includes(:values).incomplete.one_off.kept.most_recent_first
    @one_off_stories_page = current_page_from @one_off_stories
  end

  def repeatable
    @repeatable_stories = Story.includes(:values).repeatable.kept.completed_first
    @repeatable_stories_page = current_page_from @repeatable_stories
  end

  def show; end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    @story.planned_stories.build(commmit_id: @commmit.id) if @commmit

    # TODO: Split @commmit out into the action `create_from_commmit`
    respond_to do |format|
      if @story.save
        format.turbo_stream
        if @commmit
          format.html { redirect_to commmit_planned_stories_path(@commmit), notice: t('stories.notice.created') }
        else
          format.html { redirect_to stories_path, notice: t('stories.notice.created') }
        end
      else
        if @commmit
          format.turbo_stream { render turbo_stream.replace(@story, partial: 'planned_stories/add_stories/form', locals: { story: @story, commmit: @commmit }) }
        else
          format.turbo_stream { render turbo_stream.replace('story_form', partial: 'stories/form', locals: { story: @story }) }
        end
        format.html { render :new }
      end
    end
  end

  def edit; end

  def update
    story_params[:value_ids]&.reject!(&:empty?)

    respond_to do |format|
      if @story.update(story_params)
        format.turbo_stream
        format.html { redirect_to stories_path, notice: t('stories.notice.updated') }
      else
        format.turbo_stream { render turbo_stream.replace(@story, partial: 'stories/edit', locals: { story: @story }) }
        format.html { render :edit }
      end
    end
  end

  def destroy
    return unless @story.discard

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to stories_path, notice: t('stories.notice.archived') }
    end
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
