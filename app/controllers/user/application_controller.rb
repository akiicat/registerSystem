class User::ApplicationController < ApplicationController
  before_action :session_redirect_login, :except => [:login, :auth, :forgot, :password]
  before_action :session_redirect_root, :only => [:login, :auth, :forgot, :password]
  before_action :session_teacher, :except => [:login, :auth, :forgot, :password, :logout]
private

  def session_redirect_login
    redirect_to user_login_path and return unless session[:user]
  end
  def session_redirect_root
    redirect_to user_years_path and return if session[:user]
  end
  def session_teacher
    @teacher  = Teacher.find_by(:confirm => session[:user]) if session[:user]
  end

end
