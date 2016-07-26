class Admin::StudentsController < Admin::ApplicationController
  layout 'admin'
  
  def index
    @page_title = "學生年份" + NCTUEE_TITLE
    @years = Vacancy.order(:year => :desc).select(:year, :archive).distinct
    @students = Student.all
  end

  def show
    @page_title = "年度學生" + NCTUEE_TITLE
    @year = params[:id]
    @groups = Group.all
    @students = Student.where(:year => @year)
    @teachers = Teacher.all
    @vacancies = Vacancy.where(:year => @year)
  end

  def new
    @page_title = '新增學生' + NCTUEE_TITLE
    @year    = params[:year]
    @group   = Group.new
    @groups  = Group.where("id != 8")
  end

  def create
    # render :json => students_params and return
    Student.transaction do
      count = 0
      students_params.compact.each do |student|
        ap student
        s = Student.new(student)
        s.year           = year_params
        s.entry_group_id = group_params

        s = student_reset(s)
        s.waiting_list   = nil if s.waiting_list == nil or s.waiting_list <= 0

        count += 1 if s.save
      end
      flash[:notice] = "已成功新增 #{count} 位學生"
    end

    respond_to do |format|
      format.html { redirect_to admin_student_path(year_params) }
    end
  end

  def edit
    @page_title = '編輯學生' + NCTUEE_TITLE
    @groups   =  Group.where("id != 8").unshift(Group.new(:id => 0, :group => "-"))
    #render :json => @groups and return

    @student  = Student.find_by(:confirm => params[:id])

    ## only change (coop)vacancy_id to teacher_id in this action
    ## and change back at the end of edit
    v1 = @student.vacancy_id
    v2 = @student.coop_vacancy_id
    @student.vacancy_id      = Vacancy.find(v1).teacher_id if v1
    @student.coop_vacancy_id = Vacancy.find(v2).teacher_id if v2

    @year     = @student.year
    @years    = Vacancy.order(:year => :desc).select(:year, :archive).distinct

    @teachers =  Teacher.all_sort_by_name.unshift(Teacher.new(:id => 0, :name => "-"))
  end

  # three part of this action
  # - keep old [vacancy group personal]
  # - update Student field and save
  # - keep new [vacancy group personal]
  # - count, (skip verify), safe vacancy
  def update
    Student.transaction do
      begin
        @student = Student.find_by(:confirm => params[:id])

        # - keep old vacancy_id & group personal
        vacancies = Array.new
        vacancies = keep_vacancy(vacancies, @student)

        # - update Student field
        @student  = update_student(@student)
        @student.save!

        # - keep new vacancy
        vacancies = keep_vacancy(vacancies, @student)

        
        vacancies.each do |array|
          # - count vacancy
          vacancy = count_vacancy(array["vacancy_id"], array["group_id"], array["personal"])

          # - verify skipped

          # save
          vacancy.save!
        end

        # EMAIL_HERE IF STUDENT REPLACED
      rescue
        flash[:error] = "something error and transaction rollback"
      end
    end

    year = @student.year
    respond_to do |format|
      format.html { redirect_to admin_student_path(year) }
    end
  end


  # - keep old vacancy value
  # - destroy
  # - verify
  def destroy
    Student.transaction do
      begin
        @student = Student.find_by(:confirm => params[:id])

        # - keep old vacancy value
        vacancies = Array.new
        vacancies = keep_vacancy(vacancies, @student)

        # - destroy
        flash[:error] = "刪除失敗" if not @student.destroy

        vacancies.each do |array|
          # - count vacancy
          vacancy = count_vacancy(array["vacancy_id"], array["group_id"], array["personal"])
          # - verify skipped
          # save
          vacancy.save!
        end
      rescue
        flash[:error] = "something error and transaction rollback"
      end
    end

    year = @student.year
    respond_to do |format|
      format.html { redirect_to admin_student_path(year) }
    end
  end

private
  # create
  # year_params group_params students_params
  def year_params
    params.require(:year)
  end
  
  def group_params
   group = params.require(:group).permit(:id)
   group[:id]
  end

  def students_params
   std = params.require(:group).permit(:students_attributes => [:name, :phone, :email, :waiting_list, :entry])
   std[:students_attributes].values
  end

  def vacancy_confirm
    params.require(:vacancy)
  end

  def student_params
    params.require(:student).permit(
      :group_id, :entry_group_id, :vacancy_id, :coop_vacancy_id, :replaced_id, :coop_replaced_id,
      :year, :repl, :waiting_list, :name, :email, :phone, :personal, :coop_personal, :entry)
  end

  def keep_vacancy(vacancies, student)
    if student.vacancy_id
      vacancies.push({
        "group_id"    => student.group_id,
        "vacancy_id"  => student.vacancy_id,
        "personal"    => student.personal
      })
    end
    if student.coop_vacancy_id
      vacancies.push({
        "group_id"    => student.group_id,
        "vacancy_id"  => student.coop_vacancy_id,
        "personal"    => student.coop_personal
      })
    end
    return vacancies.uniq
  end

  def update_student(student)
    student_params.each do |key, value|
      begin
        student[key] = (value == "0" or value == nil) ? nil : value
      rescue
        student[:contact][key] = (value == "0" or value == nil) ? nil : value
      end
    end

    # v != nil    same as       v
    # v == nil    same as   not v or !v
    v1 = student.vacancy_id
    v2 = student.coop_vacancy_id
    p1 = student.personal
    p2 = student.coop_personal
    student.vacancy_id      = (  !v1 and  v2)                               ? v2        : v1
    student.personal        = (  !v1 and  v2)                               ? p2        : p1
    student.coop_vacancy_id = (( !v1 and  v2)  or (v1 == v2 and v1 and v2)) ? nil       : v2
    student.coop            = (   v1 and  v2  and  v1 != v2)                ? "true"    : "false"
    student.status          = (  !v1 and !v2)                               ? "waiting" : "completed"

    student.personal        = "false" if not student.vacancy_id
    student.coop_personal   = "false" if not student.coop_vacancy_id

    r1 = student.replaced_id
    r2 = student.coop_replaced_id
    student.replaced_id      = (  !r1 and  r2)                               ? r2        : r1
    student.coop_replaced_id = (( !r1 and  r2)  or (r1 == r2 and r1 and r2)) ? nil       : r2
    student.repl             = (   r1  or  r2)                               ? "true"    : "false"

    student = student_reset(student) if not student.group

    v1 = student.vacancy_id
    v2 = student.coop_vacancy_id
    student.vacancy_id       = Vacancy.find_by(:year => student.year, :teacher_id => v1).id if v1
    student.coop_vacancy_id  = Vacancy.find_by(:year => student.year, :teacher_id => v2).id if v2

    return student
  end

  def student_reset(student)
    student.vacancy_id       = nil
    student.coop_vacancy_id  = nil
    # student.replaced_id      = nil
    # student.coop_replaced_id = nil
    student.personal         = "false"
    student.coop_personal    = "false"
    student.coop             = "false"
    # student.repl             = "false"
    student.status           = "waiting"
    return student
  end

  def count_vacancy(params_vacancy_id, params_group_id, params_personal)
    # array [vacancy_id, group_id, is_personal]
    vacancy  = Vacancy.find(params_vacancy_id)
    year     = vacancy.year
    group    = Group.find(params_group_id)
    personal = params_personal
    if personal
      sql      = 'year = ? AND ((vacancy_id = ? AND personal = ?) OR (coop_vacancy_id = ? AND coop_personal = ?))'
      students = Student.where(sql, year, vacancy, personal, vacancy, personal)
    else
      sql      = 'year = ? AND group_id = ? AND ((vacancy_id = ? AND personal = ?) OR (coop_vacancy_id = ? AND coop_personal = ?))'
      students = Student.where(sql, year, group, vacancy, personal, vacancy, personal)
    end

    count    = 0.0
    students.each { |student| count += (student.coop) ? vacancy.ratio : 1.0 }
    
    # update_vacancy(vacancy, used|number, group, count)
    vacancy  = update_vacancy(vacancy, "used", group, count, personal)
    
    return vacancy
  end

  def update_vacancy(vacancy, type, group, count, personal)
    group = (personal) ? 8 : group.id
    groups                   = JSON.parse(vacancy[type])
    groups["group_#{group}"] = count.to_s
    vacancy[type]            = groups.to_json

    return vacancy
  end
end
