# frozen_string_literal: true

class TagsController < ApplicationController
  before_action :find_story

  def index
    @tags = Tag.all
  end

  def create
    tag = Tag.create(tag_params)

    @story.tags << tag

    redirect_back fallback_location: story_tags_path(@story), notice: 'Added Value'
  end

  def destroy; end

  private

  def find_story
    @story = story.friendly.find(params[:story_id])
  end

  def tag_params
    params.require(:tags).permit(:name, :color)
  end
end
