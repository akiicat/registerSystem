class User::YearsController < User::ApplicationController
  layout 'user'
  # before_action
  # @teacher  = Teacher.find_by(:confirm => session[:user])

  def index
    @page_title = "年份" + NCTUEE_TITLE
    @years    = Vacancy.order(:year => :desc).select(:year, :archive).distinct
    @students = Student.all
    end

  def show
    @page_title = "年度名額" + NCTUEE_TITLE
    @year     = params[:id]
    @groups   = Group.all
    @vacancy  = @teacher.vacancies.find_by(:year => @year)
    @vacancies = Vacancy.where(:year => @year)
    @students = Student.where('year = ? AND (vacancy_id = ? OR coop_vacancy_id = ?)', @year, @vacancy.id, @vacancy.id)
  end
end
