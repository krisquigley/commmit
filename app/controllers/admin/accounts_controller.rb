class Admin::AccountsController < Admin::ApplicationController
  def index 
    @accounts = Account.order(name: :asc)
  end

  def new
    @account = Account.new
  end

  def create
    subdomain = account_params[:name].gsub(/[^0-9A-Za-z]/, '')
    @account = Account.new(account_params.merge!(subdomain: subdomain.downcase))

    if @account.save
      redirect_to({ action: :index }, notice: "Account succesfully created!")
    else
      render :new
    end
  end

  private 

  def account_params
    params.require(:account).permit(:name)
  end
end