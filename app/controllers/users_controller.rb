class UsersController < ApplicationController
  def index
    @users = User.order('LOWER(name)')
  end

  def show
    @user = User.includes(:sprints).friendly.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end