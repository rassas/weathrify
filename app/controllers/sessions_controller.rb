class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(username: params[:user][:username])

    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to root_path, flash: { notice: "Signed In successfully" }
    else
      redirect_to new_session_path, flash: { alert: "Sign In failed" }
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path, flash: { notice: "Signed Out successfully" }
  end
end
