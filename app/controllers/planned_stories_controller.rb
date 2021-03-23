# frozen_string_literal: true

class PlannedStoriesController < ApplicationController
  def create
    PlannedStory.create!(planned_story_params)
    redirect_back fallback_location: commmits_path, notice: 'Added Story'
  end

  def mark_as_done
    planned_story = PlannedStory.find(params[:planned_story_id])
    planned_story.update(completed_at: Time.now)

    redirect_back fallback_location: commmits_path, notice: 'Marked Story as Done'
  end

  def destroy
    planned_story = PlannedStory.find(params[:id])
    redirect = commmit_path(planned_story.commmit)

    return unless planned_story.destroy

    redirect_back fallback_location: redirect,
                  notice: 'Removed Story from Commmit'
  end

  private

  def planned_story_params
    params.require(:planned_story).permit(:commmit_id, :story_id, :completed_at, :planned_story_id)
  end
end
