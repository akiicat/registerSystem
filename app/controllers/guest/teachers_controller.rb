class Guest::TeachersController < Guest::ApplicationController
  layout 'guest'
  
  def index
    @page_title = "系所師資" + NCTUEE_TITLE
    @teachers = Teacher.search(params[:search])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @page_title = "系所師資" + NCTUEE_TITLE
    @teacher = Teacher.where('salt LIKE ?', "#{params[:id]}%").first

    @year      = params[:year]
    @vacancy   = @teacher.vacancies.find_by(:year => @year)
    @groups    = Group.all
    @students  = Student.all
    respond_to do |format|
      format.html {
        @vacancies = @teacher.vacancies.order(:year => :desc)
        @years     = @vacancies.pluck(:year)
      }
      format.js
    end
  end
end
