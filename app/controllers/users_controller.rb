class UsersController < ApplicationController
  protect_from_forgery except: :create

  def create
    GithubUserJob.perform_async(request.body.read)
    head :accepted
  end

  def index
    @users = User.all.includes(:team).order(name: :asc)
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

  def destroy
    @user = User.find(params[:id])

    @user.destroy
    redirect_to users_path, notice: "User succesfully deleted!"
  end

  private

  def user_params
    params.require(:user).permit(:name, :team_id)
  end
end