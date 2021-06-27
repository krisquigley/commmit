# frozen_string_literal: true

class CommmitsController < ApplicationController
  before_action :time_to_reflect?, only: :new
  before_action :check_for_current_commmit, only: %w[new create]

  def index
    set_page_and_extract_portion_from Commmit.includes(:planned_stories, :reflection).kept.most_recent_first
  end

  def archived
    set_page_and_extract_portion_from Commmit.includes(:planned_stories, :reflection).discarded.most_recent_first
  end

  def new
    @commmit = Commmit.new
  end

  def create
    @commmit = Commmit.new(commmit_params)

    if @commmit.save
      redirect_to commmit_planned_stories_path(@commmit), notice: t('commmits.notice.created')
    else
      render :new
    end
  end

  def unarchive
    @commmit = Commmit.find(params[:id])

    if Commmit.kept.where(end_date: @commmit.end_date).count.positive?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to archived_commmits_path, alert: t('commmits.notice.unable_to_unarchive') }
      end
    else
      return unless @commmit.undiscard

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to archived_commmits_path, notice: t('commmits.notice.unarchived') }
      end
    end
  end

  def destroy
    @commmit = Commmit.find(params[:id])

    return unless @commmit.discard

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to commmits_path, notice: t('commmits.notice.archived') }
    end
  end

  private

  def time_to_reflect?
    completed_commmits = Commmit.completed.limit(1)

    return unless completed_commmits.size.positive?

    most_recent_commmit = completed_commmits.first
    redirect_to new_commmit_reflection_path(most_recent_commmit, redirect: true), notice: t('commmits.reflection.notice.new') unless most_recent_commmit&.reflected?
  end

  def check_for_current_commmit
    @current_commmit = Commmit.current.count.positive?
  end

  def commmit_params
    params.require(:commmit).permit(:name, :end_date)
  end
end
