class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(username: params[:user][:username])

    if @user && @user.authenticate(params[:user][:password])
      sign_in(@user)
      redirect_to root_path, flash: { notice: "Signed In successfully" }
    else
      redirect_to new_session_path, flash: { alert: "Sign In failed" }
    end
  end

  def destroy
    sign_out
    redirect_to new_session_path, flash: { notice: "Signed Out successfully" }
  end
end
