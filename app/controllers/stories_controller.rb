# frozen_string_literal: true

class StoriesController < ApplicationController
  before_action :story, only: %i[edit update mark_as_done]
  before_action :find_commmit, if: -> { params[:commmit_id] }

  def index
    @stories = Story.most_recent_first.open
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    @story.planned_stories.build(commmit_id: @commmit.id) if @commmit

    if @story.save
      redirect_back fallback_location: new_story_path, notice: 'Created Story'
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

  private

  def find_commmit
    @commmit = Commmit.friendly.find(params[:commmit_id])
  end

  def story
    @story = Story.friendly.find(params[:id])
  end

  def story_params
    params.require(:story).permit(:goal, :reason, :notes, :repeatable, tags: %i[name color])
  end
end
