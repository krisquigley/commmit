class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save 
      redirect_to users_path, notice: "User succesfully created!"
    else
      render :new
    end
  end

  def index
    @users = User.all.includes(:team)
  end

  def show
    @user = User.includes(:tickets, :team).find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :team_id)
  end
end