# frozen_string_literal: true

class StoriesController < ApplicationController
  before_action :find_story, only: %i[edit update mark_as_done destroy]
  before_action :find_commmit, if: -> { params[:commmit_id] }

  def index
    @stories = Story.includes(:tags).kept.most_recent_first.open
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    @story.planned_stories.build(commmit_id: @commmit.id) if @commmit

    if @story.save
      redirect_to story_tags_path(@story), notice: 'Created Story'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @story.update(story_params)
      redirect
    else
      render :edit
    end
  end

  def destroy
    redirect_back fallback_location: stories_path, notice: 'Archived Story' if @story.discard
  end

  private

  def redirect
    if @commmit
      redirect_to commmit_path(@commmit), notice: 'Updated Story'
    elsif story_params[:tag_ids]
      redirect_to story_path(@story), notice: 'Updated Story'
    else
      redirect_to stories_path, notice: 'Updated Story'
    end
  end

  def find_commmit
    @commmit = Commmit.friendly.find(params[:commmit_id])
  end

  def find_story
    @story = Story.includes(:tags).friendly.find(params[:id])
  end

  def story_params
    params.require(:story).permit(:goal, :reason, :notes, :repeatable, tag_ids: [])
  end
end
