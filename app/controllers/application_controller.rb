class ApplicationController < ActionController::Base
  protect_from_forgery

  def login
    redirect_to root_path
  end

  def require_user!
    return unless Rails.env.production?
    redirect_to login_path unless request.env['REMOTE_USER']
  end
end
