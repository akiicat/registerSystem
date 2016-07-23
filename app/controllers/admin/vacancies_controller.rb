class Admin::VacanciesController < Admin::ApplicationController
  layout 'admin'

  def show
    @page_title = "教師學生與名額" + NCTUEE_TITLE
    @groups  = Group.all
    @vacancy = Vacancy.find_by(:confirm => vacancy_confirm)
    @teacher = @vacancy.teacher
    @year    = @vacancy.year

    @students = Student.where('year = ? AND (vacancy_id = ? OR coop_vacancy_id = ?)', @year, @vacancy, @vacancy).order(:group_id => :asc)
    @teachers = Teacher.all
    @vacancies = Vacancy.where(:year => @year)
  end

  def new
    @page_title = "新增學生" + NCTUEE_TITLE
    @vacancy  = Vacancy.find_by(:confirm => vacancy_confirm)
    @teacher  = @vacancy.teacher
    @year     = @vacancy.year
    @groups   = Group.where("id != 8")
    @students = Student.where(:year => @year).order(:group_id => :asc)
    @teachers = Teacher.where("id != ?", @teacher)
  end

private

  def vacancy_confirm
    params.require(:id)
  end

end
