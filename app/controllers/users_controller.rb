class UsersController < ApplicationController
  def index
    @users = User.order('LOWER(name)')
  end

  def show
    @user = User.includes(:retrospectives).friendly.find(params[:id])
    @retrospectives = @user.retrospectives.order(created_at: :desc)

    @happiness_values = @retrospectives.limit(10)
                        .select(:created_at, :role_happiness, :team_happiness, :company_happiness).reverse.to_json
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end