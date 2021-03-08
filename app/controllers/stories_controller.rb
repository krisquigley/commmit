# frozen_string_literal: true

class StoriesController < ApplicationController
  before_action :story, only: %i[edit update]

  def index
    @stories = Story.most_recent
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)

    if @story.save
      redirect_to stories_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @story.update(story_params)
      redirect_back fallback_location: stories_path
    else
      render :edit
    end
  end

  protected

  def story
    @story = Story.friendly.find(params[:id])
  end

  def story_params
    params.require(:story).permit(:i_want, :so_that, :notes, :commmit_id)
  end
end
