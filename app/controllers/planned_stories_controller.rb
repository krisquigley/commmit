# frozen_string_literal: true

class PlannedStoriesController < ApplicationController
  def create
    commmit = Commmit.find(planned_story_params[:commmit_id])
    commmit.planned_stories.create(story_id: params[:story_id])

    redirect_to commmit_path(commmit), notice: t('stories.notice.added')
  end

  def mark_as_done
    planned_story = PlannedStory.find(params[:planned_story_id])
    planned_story.update(completed_at: Time.now)

    redirect_to commmit_path(planned_story.commmit), notice: t('stories.notice.done')
  end

  def mark_as_not_done
    planned_story = PlannedStory.find(params[:planned_story_id])
    planned_story.update(completed_at: nil)

    redirect_to commmit_path(planned_story.commmit), notice: t('stories.notice.not_done')
  end

  def destroy
    planned_story = PlannedStory.find(params[:id])
    redirect = commmit_path(planned_story.commmit)

    return unless planned_story.destroy

    redirect_back fallback_location: redirect,
                  notice: t('stories.notice.removed')
  end

  private

  def planned_story_params
    params.require(:planned_story).permit(:commmit_id, :story_id, :completed_at, :planned_story_id)
  end
end
