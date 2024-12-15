module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :user_signed_in?
    helper_method :current_user
  end

  private

  def current_user
    @current_user ||= session[:user_id] && User.find_by(id: session[:user_id])
  end

  def authenticate_user!
    unless user_signed_in?
      redirect_to new_session_path, flash: { notice: "Sign In first!" }
    end
  end

  def user_signed_in?
    return false if current_user.blank?

    true
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end
end
