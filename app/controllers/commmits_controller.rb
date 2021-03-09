# frozen_string_literal: true

class CommmitsController < ApplicationController
  def show
    @commmit = Commmit.includes(:stories)
                      .order('stories.completed_at desc, stories.created_at desc')
                      .friendly.find(params[:id])
    @stories = Story.most_recent_first.unassigned
  end

  def index
    @commmits = Commmit.includes(:stories).most_recent
  end

  def new
    @commmit = Commmit.new
  end

  def create
    @commmit = Commmit.new(commmit_params)

    if @commmit.save
      redirect_to @commmit, notice: 'Commmit succesfully created.'
    else
      render :new
    end
  end

  protected

  def commmit_params
    params.require(:commmit).permit(:name, :length_in_days, :start_date)
  end
end
