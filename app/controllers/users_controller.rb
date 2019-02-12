class UsersController < ApplicationController
  def index
    @users = User.order('LOWER(name)').includes(:team)
  end

  def show
    @user = User.includes(:tickets, :team).find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_params)

    if @user.save
      redirect_to users_path, notice: "User succesfully updated!"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :team_id)
  end
end