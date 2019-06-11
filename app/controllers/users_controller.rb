class UsersController < ApplicationController
  def index
    @users = User.order('LOWER(name)')
  end

  def show
    @user = User.includes(:retrospectives).friendly.find(params[:id])
    @retrospectives = @user.retrospectives.order(created_at: :desc)
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end