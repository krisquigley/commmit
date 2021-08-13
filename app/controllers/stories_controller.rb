# frozen_string_literal: true

class StoriesController < ApplicationController
  before_action :find_story, only: %i[show edit update mark_as_done destroy unarchive]
  before_action :find_commmit, if: -> { params[:commmit_id] }

  def index; end

  def archived
    @archived_stories_page = current_page_from archived_stories
  end

  def one_off
    @one_off_stories_page = if params[:search].present?
                              OpenStruct.new(records: Story.search(params[:search],
                                                                   filters: 'repeatable = false',
                                                                   limit: 50),
                                             first?: true,
                                             last?: true)
                            else
                              current_page_from one_off_stories
                            end
  end

  def repeatable
    @repeatable_stories_page = if params[:search].present?
                                 OpenStruct.new(records: Story.search(params[:search],
                                                                      filters: 'repeatable = true',
                                                                      limit: 50),
                                                first?: true,
                                                last?: true)
                               else
                                 current_page_from repeatable_stories
                               end
  end

  def one_off_commmit_goal
    @one_off_commmit_goal_page = if params[:search].present?
                                   OpenStruct.new(records: Story.search(params[:search],
                                                                        filters: 'repeatable = false',
                                                                        limit: 50),
                                                  first?: true,
                                                  last?: true)
                                 else
                                   current_page_from one_off_stories
                                 end
  end

  def repeatable_commmit_goal
    @repeatable_commmit_goal_page = if params[:search].present?
                                      OpenStruct.new(records: Story.search(params[:search],
                                                                           filters: 'repeatable = true',
                                                                           limit: 50),
                                                     first?: true,
                                                     last?: true)
                                    else
                                      current_page_from repeatable_stories
                                    end
  end

  def show; end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)

    respond_to do |format|
      if @story.save
        format.turbo_stream
        format.html { redirect_to stories_path, notice: t('stories.notice.created') }
      else
        format.turbo_stream { render turbo_stream.replace('story_form', partial: 'stories/form', locals: { story: @story }) }
        format.html { render :new }
      end
    end
  end

  def create_from_commmit
    @story = Story.new(story_params)
    @story.planned_stories.build(commmit_id: @commmit.id)

    respond_to do |format|
      if @story.save
        format.turbo_stream
        format.html { redirect_to commmit_planned_stories_path(@commmit), notice: t('stories.notice.created') }
      else
        format.turbo_stream { render turbo_stream.replace(@story, partial: 'planned_stories/add_stories/form', locals: { story: @story, commmit: @commmit }) }
        format.html { render :new }
      end
    end
  end

  def create_commmit_goal
    @story = Story.new(story_params)

    respond_to do |format|
      if @story.save
        format.turbo_stream
      else
        format.turbo_stream { render turbo_stream.replace(@story, partial: 'stories/choose_commmit_goal/form', locals: { story: @story }) }
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

  def unarchive
    return unless @story.undiscard

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to archived_stories_path, notice: t('stories.notice.unarchived') }
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

  def one_off_stories
    @one_off_stories ||= Story.includes(:values).incomplete.one_off.kept.most_recent_first
  end

  def repeatable_stories
    @repeatable_stories ||= Story.includes(:values).repeatable.kept.completed_first
  end

  def archived_stories
    @archived_stories ||= Story.includes(:values).discarded.most_recent_first
  end

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
