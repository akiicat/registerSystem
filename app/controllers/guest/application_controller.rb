class Guest::ApplicationController < ApplicationController
  before_action :session_teacher

private
  def session_teacher
    @teacher_session  = Teacher.find_by(:confirm => session[:user]) if session[:user]
  end
end
