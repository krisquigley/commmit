# frozen_string_literal: true

class StoriesController < ApplicationController
  before_action :story, only: %i[edit update mark_as_done]

  def index
    @stories = Story.most_recent_first.open
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)

    if @story.save
      redirect_to new_story_path, notice: 'Created Story'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @story.update(story_params)
      redirect_to stories_path, notice: 'Updated Story'
    else
      render :edit
    end
  end

  protected

  def story
    @story = Story.friendly.find(params[:id])
  end

  def story_params
    params.require(:story).permit(:goal, :reason, :notes, :repeatable, tags: %i[name color])
  end
end
