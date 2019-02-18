class UsersController < ApplicationController
  def index
    @users = User.order('LOWER(name)').includes(:team)
  end

  def show
    @user = User.includes(:team).find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :team_id)
  end
end