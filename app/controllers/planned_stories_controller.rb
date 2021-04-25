# frozen_string_literal: true

class PlannedStoriesController < ApplicationController
  def create
    @commmit = Commmit.find(planned_story_params[:commmit_id])
    @planned_story = @commmit.planned_stories.create(story_id: params[:story_id])

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to commmit_path(@commmit), notice: t('stories.notice.added') }
    end
  end

  def mark_as_done
    @planned_story = PlannedStory.find(params[:planned_story_id])
    @planned_story.update(completed_at: Time.now)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to commmit_path(@planned_story.commmit), notice: t('stories.notice.done') }
    end
  end

  def mark_as_not_done
    @planned_story = PlannedStory.find(params[:planned_story_id])
    @planned_story.update(completed_at: nil)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to commmit_path(@planned_story.commmit), notice: t('stories.notice.not_done') }
    end
  end

  def destroy
    @planned_story = PlannedStory.find(params[:id])
    redirect = commmit_path(@planned_story.commmit)

    return unless @planned_story.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to redirect, notice: t('stories.notice.removed') }
    end
  end

  private

  def planned_story_params
    params.require(:planned_story).permit(:commmit_id, :story_id, :completed_at, :planned_story_id)
  end
end
