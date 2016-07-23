class Admin::ApplicationController < ApplicationController
  before_action :session_redirect_login, :except => [:login, :auth]
  before_action :session_redirect_root, :only => [:login, :auth]

private

  def session_redirect_login
    redirect_to admin_login_path and return unless session[:admin]
  end
  def session_redirect_root
    redirect_to admin_years_path and return if session[:admin]
  end

end
