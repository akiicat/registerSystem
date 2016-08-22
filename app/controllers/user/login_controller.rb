class User::LoginController < User::ApplicationController
  layout 'login'

  def login
    @page_title = '教師登入頁面' + NCTUEE_TITLE
    @teacher = Teacher.new 
  end

  def auth
    @teacher = Teacher.find_by(account_params)
    
    if @teacher.blank?
      render :js => mtr_toast("帳號輸入錯誤") and return

    elsif @teacher.password != Digest::SHA1.hexdigest(params[:teacher][:password] + @teacher.salt)
      render :js => mtr_toast("密碼輸入錯誤") and return
    end

    session[:user] = @teacher.confirm
    @year = Vacancy.pluck(:year).uniq.sort.last
    # auth.js.coffee to redirect
  end
  
  def forgot
    @page_title = '教師登入頁面 - 忘記帳號或密碼' + NCTUEE_TITLE
    @teacher = Teacher.new
  end
  def password
    @teacher = Teacher.find_by(email_params)
    render :js => mtr_toast("輸入錯誤 沒有這個信箱") and return if not @teacher
    render :js => mtr_toast("請一分鐘後再重試") and return if (Time.now - @teacher.updated_at) < 60

    password = SecureRandom.hex[0..7]
    @teacher.password = Digest::SHA1.hexdigest(password + @teacher.salt)
    render :js => mtr_toast("密碼更新失敗") and return if not @teacher.save
    # EMAIL_HERE
    TeacherMailer.send_password(@teacher, password).deliver_later 
    render :js => mtr_toast("已寄送新密碼") and return
  end

  def logout
    #@page_title = '教師登出頁面' + NCTUEE_TITLE
    session[:user] = nil
    redirect_to user_login_path
  end

private

  def account_params
    params.require(:teacher).permit(:account)
  end
  def email_params
    params.require(:teacher).permit(:email)
  end

end
