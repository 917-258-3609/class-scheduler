class UsersController < ApplicationController
  before_action :set_user, only: [ :payment, :pay ]
  def payment
  end

  def pay
    if @user.pay(params[:amount].to_f)
      redirect_to(@user.accountable)
    else
      render :payment, status: :unprocessable_entity
    end 
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end