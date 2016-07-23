class Admin::YearsController < Admin::ApplicationController
  layout 'admin'
  before_action :vacancy_element, :only => [:show, :edit, :remain, :ratio]

  def index
    @page_title = "名額年份" + NCTUEE_TITLE
    @years = Vacancy.order(:year => :desc).select(:year, :archive).distinct
    @students = Student.all
  end

  def ratio
    @page_title = "共指所用名額" + NCTUEE_TITLE
    @students = Student.all
  end

  def archive
    #@page_title = "封存" + NCTUEE_TITLE
    @vacancies = Vacancy.where(:year => params[:id])
    archive = @vacancies.first.archive ? false : true
    year = @vacancies.first.year
    if not @vacancies.update_all(:archive => archive)
      flash[:error] = "#{params[:id]} 封存失敗"
    end

    # goto show
    respond_to do |format|
      format.html { redirect_to admin_year_path(year) }
    end
  end

  def show
    @page_title = "年度名額" + NCTUEE_TITLE
    # render for csv format
    @categories = Category.all
    @titles = Title.all

    respond_to do |format|
      format.html
      format.csv {
        @students = Student.where(:year => @year)
      }
    end
  end

  def edit
    @page_title = "編輯名額" + NCTUEE_TITLE
  end

  def remain
    @page_title = "剩餘名額" + NCTUEE_TITLE
  end

  def create
    if Vacancy.where(:year => year_params).blank?
      Admin.transaction do
        groups = Hash.new
        Group.all.each { |group| groups["group_" + group.id.to_s] = 0.0 }

        Teacher.all.each do |teacher|
          Vacancy.create!(
            :year    => year_params,
            :ratio   => teacher.default_ratio,
            :teacher => teacher,
            :archive => false,

            :number  => groups.to_json,
            :used    => groups.to_json
            )
        end
      end
      flash[:notice] = "新增成功"
    else
      flash[:error] = "年份不得重複"
    end
    
    respond_to do |format|
      format.html { redirect_to admin_years_path }
    end
  end
  
  # Update each vacancy's elements
  def update
    vacancies = Hash.new
    year = Vacancy.find(vacancies_params.keys.first).year
    vacancies_params.each do |vacancy, groups|
      vacancies[vacancy] = Hash["number" => groups.to_json]
    end 

    if not Vacancy.update(vacancies.keys, vacancies.values)
      flash[:error] = "更新失敗"
    end

    # goto show
    respond_to do |format|
      format.html { redirect_to admin_year_path(year) }
    end
  end

  def destroy
    year = params[:id]
    vacancies = Vacancy.where(:year => year)
    students  = Student.where(:year => year)

    Admin.transaction do
      if students.destroy_all and vacancies.destroy_all
        flash[:notice] = "刪除成功"
      else
        flash[:error] = "刪除失敗"
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_years_path }
    end
  end
  
private

  def year_params
    params.require(:year)
  end

  def vacancies_params
    params.require(:vacancy_ids)
  end

  # before_action :only => [:show, :edit, :remain, :ratio]
  def vacancy_element
    @vacancies = Vacancy.where(:year => params[:id])
    @archive   = @vacancies.first.archive ? '(封存)' : ''
    @year      = @vacancies.first.year
    @groups    = Group.all
    @teachers  = Teacher.all_sort_by_name
  end
end
