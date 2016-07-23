class User::TeachersController < User::ApplicationController
  layout 'user'

  def edit
    @page_title = "修改密碼" + NCTUEE_TITLE
  end


  def update
    # @teacher.update(teacher_params)
    pw_old = Digest::SHA1.hexdigest(pw_old_params + @teacher.salt)
    pw_new = Digest::SHA1.hexdigest(pw_new_params + @teacher.salt)
    pw_cnf = Digest::SHA1.hexdigest(pw_cnf_params + @teacher.salt)

    if pw_old_params.blank?
      # flash[:notice] = '個人資料已更新 密碼未更新'
      flash[:notice] = '密碼未更新'
    else
      flash[:error] = '舊密碼輸入錯誤' and render :edit and return if @teacher.password != pw_old
      flash[:error] = '密碼驗證失敗'   and render :edit and return if pw_new != pw_cnf
      flash[:error] = '密碼不能為空白' and render :edit and return if pw_new_params.blank?
      flash[:error] = '密碼更新失敗'   and render :edit and return if not @teacher.update(:password => pw_new)
      # flash[:notice] = '個人資料已更新 密碼已更新'
      flash[:notice] = '密碼已更新'
    end

    respond_to do |format|
      format.html { 
        flash[:error] = nil
        redirect_to user_years_path 
      }
    end
  end
private
  def teacher_params
    params.require(:admin).permit(:email)
  end
  def pw_old_params
    params.require(:teacher).permit(:password_old)[:password_old]
  end
  def pw_new_params
    params.require(:teacher).permit(:password)[:password]
  end
  def pw_cnf_params
    params.require(:teacher).permit(:password_confirmation)[:password_confirmation]
  end
end
