class User::StudentsController < User::ApplicationController
  layout 'user'
  before_action :archive_check, only: [:create, :accept, :destroy]
 
  def show
    @page_title = "學生資料" + NCTUEE_TITLE
    @student   = Student.find_by(:confirm => params[:id])
    @teachers  = Teacher.where('confirm != ?', session[:user])
    @groups    = Group.where('id != 8')
    @year      = @student.year
    @vacancies = Vacancy.where(:year => @year)
    respond_to do |format|
      format.html {
        @vacancy   = @teacher.vacancies.find_by(:year => @year)
      }
      format.js
    end
  end

  def new
    @page_title = '新增學生' + NCTUEE_TITLE
    @students   = Student.where(:year => params[:year], :entry => 'attended')
    @groups     = Group.where("id != 8")
    @year       = @students.first.year
  end
  def create
    raise  "[AKIILOG] #{commit_params} - commit error" if not commit_params.in? ['新增', '邀請']
    Student.transaction do
      begin
        # - keep old [vacancy group personal]
        vacancies = Array.new
        vacancies = keep_vacancy(vacancies, @student)

        # - update Student field and save
        vacancy             = @teacher.vacancies.find_by(:year => @year)
        @student.vacancy_id = vacancy.id
        @student            = update_student(@student)
        @student.save!

        # - keep new vacancy
        vacancies = keep_vacancy(vacancies, @student)

        vacancies.each do |array|
          # - count and verify vacancy
          vacancy = count_vacancy(array["vacancy_id"], array["group_id"], array["personal"])
          result  = (vacancy.id != @student.coop_vacancy_id) ? verify_vacancy(vacancy) : 'skip verify'
          # save
          raise "[AKIILOG] group vacancy is not enough" if result.in? ['failed']
          vacancy.save!
        end

        # EMAIL_HERE
        if commit_params.in? ['新增']
          TeacherMailer.accept_student(@teacher, @student).deliver_later
          StudentMailer.accepted(@student, [@teacher]).deliver_later
        end
        if commit_params.in? ['邀請']
          teacher_co = Vacancy.find(@student.coop_vacancy_id).teacher
          TeacherMailer.invite_coopTeacher(teacher_co, @student, @teacher).deliver_later
        end

      rescue
        @student = reset_student(@student)
        @student.save!
        vacancies.each do |array|
          vacancy = count_vacancy(array["vacancy_id"], array["group_id"], array["personal"])
          vacancy.save!
        end
        flash[:error] = "名額不足，有名額上的問題，請聯絡系辦"
      end
    end
    respond_to do |format|
      format.html { redirect_to user_year_path(@year) }
    end
  end

  def accept
    Student.transaction do
      begin
        # - keep old [vacancy group personal]
        vacancies = Array.new
        vacancies = keep_vacancy(vacancies, @student)
        status_old = @student.status

        # - update Student field and save
        @student.coop_personal = params[:personal]
        @student.status = "completed"
        @student.save!

        # - keep new vacancy
        vacancies = keep_vacancy(vacancies, @student)

        vacancies.each do |array|
          # - count and verify vacancy
          vacancy = count_vacancy(array["vacancy_id"], array["group_id"], array["personal"])
          result  = verify_vacancy(vacancy)
          # save
          raise "[AKIILOG] group vacancy is not enough" if result.in? ['failed']
          vacancy.save!
        end

        # EMAIL_HERE
        t1 = Vacancy.find(@student.vacancy_id).teacher
        t2 = Vacancy.find(@student.coop_vacancy_id).teacher
        TeacherMailer.accept_student(t1, @student).deliver_later
        TeacherMailer.accept_student(t2, @student).deliver_later
        StudentMailer.accepted(@student, [t1, t2]).deliver_later
      rescue
        @student.coop_personal = false
        @student.status = status_old
        @student.save!
        vacancies.each do |array|
          vacancy = count_vacancy(array["vacancy_id"], array["group_id"], array["personal"])
          vacancy.save!
        end
        flash[:error] = "名額不足，有名額上的問題，請聯絡系辦"
      end
    end
    respond_to do |format|
      format.html { redirect_to user_year_path(@year) }
    end
  end

  # if destroy, cancel or reject 
  def destroy
    Student.transaction do
      begin
        # - keep old vacancy
        vacancies = Array.new
        vacancies = keep_vacancy(vacancies, @student)

        # - reset student and save
        @student  = reset_student(@student)
        @student.save!

        # - conut vacancy and save
        vacancies.each do |array|
          vacancy = count_vacancy(array["vacancy_id"], array["group_id"], array["personal"])
          vacancy.save!
        end
        # EMAIL_HERE
      rescue
        flash[:error] = "取消指導/取消邀請/拒絕邀請學生失敗"
      end
    end

    respond_to do |format|
      format.html { redirect_to user_year_path(@year) }
    end
  end

private

  def student_params
    params.require(:student).permit(:group_id, :personal, :coop_vacancy_id)
  end

  def commit_params
    params.require(:commit)
  end
  # before_action :archive_check, only: [:create, :accept, :destroy]
  def archive_check
    @student = Student.find_by(:confirm => params[:confirm]) if params[:confirm]
    @student = Student.find_by(:confirm => params[:id])      if params[:id]
    @year     = @student.year
    if Vacancy.find_by(:year => @year).archive.in? [true]
      flash[:error] = "#{year} 年度 已封存"
      redirect_to user_years_path and return
    end
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
    student.group_id   = student_params[:group_id]
    student.personal   = student_params[:personal]
    student.coop       = (commit_params.in? ['邀請']) ? "true" : "false"
    student.coop_vacancy_id = Vacancy.find_by(
        :year      => student.year, 
        :teacher_id => student_params[:coop_vacancy_id]).id if commit_params.in? ['邀請']
    student.status     = "completed" if commit_params.in? ['新增']
    student.status     = "inviting"  if commit_params.in? ['邀請']
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
    students.each do |student|
      unless student.status.in? ['inviting'] and student.coop_vacancy_id == vacancy.id   
        count += (student.coop) ? vacancy.ratio : 1.0
      end
    end
    
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
  def verify_vacancy(vacancy)
    remain_list = to_remain(vacancy)
    remain_list.each do |key, value|
      return "failed" if value.to_f < 0
    end

    return "success"
  end
  def reset_student(student)
    student.group_id         = nil
    student.vacancy_id       = nil
    student.coop_vacancy_id  = nil
    student.personal         = "false"
    student.coop_personal    = "false"
    student.coop             = "false"
    student.status           = "waiting"
    return student
  end

end
