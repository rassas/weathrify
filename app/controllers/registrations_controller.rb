class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)

    if @user.save
      sign_in(@user)
      redirect_to root_path, flash: { notice: "Signed up successfully" }
    else
      flash[:alert] = "User not created"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
