class Admin::AdminsController < Admin::ApplicationController
  layout 'admin'

  def index
    @page_title = "管理員個人資料" + NCTUEE_TITLE
    @admin = Admin.find_by(:confirm => session[:admin])

    respond_to do |format|
      format.html
    end
  end

  def edit
    @page_title = "編輯名額" + NCTUEE_TITLE
    @admin = Admin.find_by(:confirm => params[:id])

    respond_to do |format|
      format.html
    end
  end
  
  def update
    @admin = Admin.find_by(:confirm => params[:id])
    if @admin.confirm == session[:admin]
      @admin.update(admin_params)
      pw_old = Digest::SHA1.hexdigest(pw_old_params + @admin.salt)
      pw_new = Digest::SHA1.hexdigest(pw_new_params + @admin.salt)
      pw_cnf = Digest::SHA1.hexdigest(pw_cnf_params + @admin.salt)

      if pw_old_params.blank?
        flash[:notice] = '個人資料已更新 密碼未更新'
      else
        flash[:error] = '舊密碼輸入錯誤' and render :edit and return if @admin.password != pw_old
        flash[:error] = '密碼驗證失敗'   and render :edit and return if pw_new != pw_cnf
        flash[:error] = '密碼不能為空白' and render :edit and return if pw_new_params.blank?
        flash[:error] = '密碼更新失敗'   and render :edit and return if not @admin.update(:password => pw_new)
        flash[:notice] = '個人資料已更新 密碼已更新'
      end
    else
      flash[:error] = "驗證失敗"
    end

    # goto show
    respond_to do |format|
      format.html { 
        flash[:error] = nil
        redirect_to admin_admins_path 
      }
    end
  end
  
private
  def admin_params
    params.require(:admin).permit(:name, :account, :email)
  end
  def pw_old_params
    params.require(:admin).permit(:password_old)[:password_old]
  end
  def pw_new_params
    params.require(:admin).permit(:password)[:password]
  end
  def pw_cnf_params
    params.require(:admin).permit(:password_confirmation)[:password_confirmation]
  end

end
