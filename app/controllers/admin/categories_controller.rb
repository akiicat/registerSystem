class Admin::CategoriesController < Admin::ApplicationController
  layout "admin"

  def index
    @page_category = '職稱' + NCTUEE_TITLE
    @categories = Category.all
    @category = Category.new
  end

  def edit
    @page_category = '編輯職稱' + NCTUEE_TITLE
    @categories = Category.all
  end

  def create
    @category = Category.new(category_params)
    render :js => mtr_toast("新增失敗") and return if not @category.save
  end
  
  def update
    Category.transaction do
      begin
        categories_params.each do |key, value|
          Category.find(key).update!(:category => value["category"])
        end
      rescue Exception => e
        flash[:error] = "名稱重複"
        redirect_to edit_admin_categories_path and return
      end
    end
    respond_to do |format|
      format.html { 
        flash[:error] = nil
        redirect_to admin_categories_path }
    end
  end

  def destroy
    @category = Category.find(params[:id])
    render :js => mtr_toast("刪除失敗") and return if not @category.destroy
  end
  
private

  def category_params
    params.require(:category).permit(:category)
  end
  def categories_params
    params.require(:category_ids)
  end
end

