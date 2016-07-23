class Develop::AdminsController < Develop::ApplicationController
  layout 'admin'

  def index
    @page_title = 'NCTUEE Developer Console'
    @admins = Admin.all
  end

  def new
    @page_title = 'NCTUEE Developer Console - New'
    @admin = Admin.new
  end

  def edit
    @page_title = 'NCTUEE Developer Console - Edit'
    @admin = Admin.find(params[:id])
    @admin.password = ''
  end

  def create
    @admin = Admin.new(admin_params)
    @admin.salt = SecureRandom.hex
    @admin.password = Digest::SHA1.hexdigest(@admin.password + @admin.salt)
    flash[:error] = "新增失敗" unless @admin.save
    respond_to do |format|
      format.html { redirect_to develop_admins_path }
    end
  end
  
  def update
    @admin = Admin.find(params[:id])
    params[:admin][:password] = (params[:admin][:password].blank?) ? @admin.password : Digest::SHA1.hexdigest(params[:admin][:password] + @admin.salt)
    flash[:error] = "更新失敗" unless @admin.update(admin_params)
    respond_to do |format|
      format.html { redirect_to develop_admins_path }
    end
  end

  def destroy
    @admin = Admin.find(params[:id])
    flash[:error] = "刪除失敗" unless @admin.destroy
    respond_to do |format|
      format.html { redirect_to develop_admins_path }
    end
  end
  
private

  def admin_params
    params.require(:admin).permit(:name, :email, :account, :password)
  end
end
