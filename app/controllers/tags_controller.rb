# frozen_string_literal: true

class TagsController < ApplicationController
  before_action :find_story, if: -> { params[:story_id] }

  def show
    @tags = Tag.all
  end

  def create
    tag = Tag.find_or_create_by(tag_params)
    @story.tags << tag

    redirect_back fallback_location: story_tags_path(@story), notice: 'Created Value'
  end

  private

  def find_story
    @story = Story.friendly.find(params[:story_id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
