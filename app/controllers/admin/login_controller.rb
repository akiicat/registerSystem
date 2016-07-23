class Admin::LoginController < Admin::ApplicationController
  layout 'login'

  def login
    @page_title = '管理員登入頁面' + NCTUEE_TITLE
    @admin = Admin.new 
  end

  def auth
    #@page_title = '管理員登入中...' + NCTUEE_TITLE
    @admin = Admin.find_by(account_params)
    
    if @admin.blank? or @admin.password != Digest::SHA1.hexdigest(params[:admin][:password] + @admin.salt)
      flash[:error] = "帳號或密碼輸入錯誤"
    else
      session[:admin] = @admin.confirm
    end

    respond_to do |format|
      format.html { redirect_to admin_years_path }
    end
  end
  
  def logout
    #@page_title = '管理員登出頁面' + NCTUEE_TITLE
    session[:admin] = nil
    respond_to do |format|
      format.html { redirect_to admin_login_path }
    end
  end

private

  def account_params
    params.require(:admin).permit(:account)
  end

  def password_params
    params.require(:admin).permit(:password)
  end

end
