class Admin::TeachersController < Admin::ApplicationController
  layout 'admin'
  before_action :left_bar, :only => [:index, :new, :edit, :password]

  def index
    @page_title = "系所師資" + NCTUEE_TITLE
  end

  def password
    @page_title = "師資帳號管理" + NCTUEE_TITLE
  end

  def sends
    #@page_title = "密碼寄送..." + NCTUEE_TITLE
    @teachers_send = Teacher.where(:id => params[:teacher_ids])
    @teachers_send.each do |teacher|
      password = SecureRandom.hex[0..7]
      teacher.password = Digest::SHA1.hexdigest(password + teacher.salt)
      flash[:error] = "密碼更新失敗" if not teacher.save
      # EMAIL_HERE
      TeacherMailer.send_password(teacher, password).deliver_later
    end

    respond_to do |format|
      format.html { redirect_to admin_teachers_path, :method => :get }
    end
  end

  def new
    @page_title = "新增師資" + NCTUEE_TITLE
    @teacher    = Teacher.new
    @titles     = Title.all
    @categories = Category.all
  end

  def create
    @page_title = "教師新增..." + NCTUEE_TITLE
    @teacher          = Teacher.new(teacher_params)
    @teacher.salt     = SecureRandom.hex
    @teacher.password = Digest::SHA1.hexdigest(@teacher.password + @teacher.salt)

    if @teacher.save
      Admin.transaction do
        groups = Hash.new
        Group.all.each { |group| groups["group_#{group.id}"] = 0.0 }

        years = Vacancy.select(:year, :archive).distinct
        years.each do |year|
          Vacancy.create!(
            :year    => year.year,
            :archive => year.archive,
            :teacher => @teacher,
            :ratio   => @teacher.default_ratio,

            :number  => groups.to_json,
            :used    => groups.to_json
            )
        end
      end
    else
      flash[:error] = "新增失敗"
    end

    respond_to do |format|
      format.html { redirect_to admin_teachers_path, :method => :get }
    end
  end



  def edit
    @page_title = "編輯師資" + NCTUEE_TITLE
    @teacher    = Teacher.find(params[:id])
    @teacher.password = ''
    @titles     = Title.all
    @categories = Category.all
    @std_count  = student_count(@teacher)

    #render :json => @std_count and return
  end

  def update
    #@page_title = "教師更新..." + NCTUEE_TITLE
    @teacher = Teacher.find(params[:id])
    password = params[:teacher][:password]
    params[:teacher][:password] = (password.blank?) ? @teacher.password : Digest::SHA1.hexdigest(password + @teacher.salt)
    flash[:error] = "更新失敗" if not @teacher.update(teacher_params)
    
    respond_to do |format|
      format.html { redirect_to admin_teachers_path, :method => :get }
    end
  end

  def destroy
    #@page_title = "教師刪除..." + NCTUEE_TITLE
    @teacher   = Teacher.find(params[:id])
    @std_count = student_count(@teacher)
    flash[:error] = "刪除失敗" if @std_count == 0 and not @teacher.destroy

    respond_to do |format|
      format.html { redirect_to admin_teachers_path, :method => :get }
    end
  end

private

  def teacher_params
    params.require(:teacher).permit(:name, :account, :password, :title_id, 
        :education, :specialty, :phoneO, :officeO, :phoneL, :officeL, :email, :default_coop_ratio, :note, :category_ids => [])
  end

  # use to render js page
  # before_action :index, :sends, :create, :update, :destroy
  def left_bar
    @titles = Title.all
    @teachers = Teacher.all
  end

  def student_count(teacher)
    code = ""
    teacher.vacancies.each do |vacancy|
      code +=  "(Student.where(:vacancy_id => "+vacancy.id.to_s+")).or(Student.where(:coop_vacancy_id => "+vacancy.id.to_s+")).or"
    end
    code = code[0..-4] + ".count"
    return eval(code)
  end
end
