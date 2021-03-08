# frozen_string_literal: true

class CommmitsController < ApplicationController
  def show
    @commmit = Commmit.includes(:stories).friendly.find(params[:id])
    @stories = Story.most_recent.unassigned
  end

  def index
    @commmits = Commmit.most_recent
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

  def add_story
    raise params.inspect
  end

  protected

  def commmit_params
    params.require(:commmit).permit(:name, :length_in_days)
  end
end
