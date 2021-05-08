# frozen_string_literal: true

class CommmitsController < ApplicationController
  def index
    set_page_and_extract_portion_from Commmit.includes(:planned_stories).kept.most_recent_first
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

  def destroy
    @commmit = Commmit.find(params[:id])

    return unless @commmit.discard

    redirect_back fallback_location: commmits_path,
                  notice: t('commmits.notice.archived')
  end

  private

  def commmit_params
    params.require(:commmit).permit(:name)
  end
end
