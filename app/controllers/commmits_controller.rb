class CommmitsController < ApplicationController
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

  protected

  def commmit_params
    params.require(:commmit).permit(:name, :length_in_days)
  end
end
