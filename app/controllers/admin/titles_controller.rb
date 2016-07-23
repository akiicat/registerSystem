class Admin::TitlesController < Admin::ApplicationController
  layout "admin"

  def index
    @page_title = '職稱' + NCTUEE_TITLE
    @titles = Title.all
    @title = Title.new
  end

  def edit
    @page_title = '編輯職稱' + NCTUEE_TITLE
    @titles = Title.all
  end

  def create
    @title = Title.new(title_params)
    render :js => mtr_toast("新增失敗") and return if not @title.save
  end
  
  def update
    Title.transaction do
      begin
        titles_params.each do |key, value|
          Title.find(key).update!(:title => value["title"])
        end
      rescue Exception => e
        flash[:error] = "名稱重複"
        redirect_to edit_admin_titles_path and return
      end
    end
    respond_to do |format|
      format.html { 
        flash[:error] = nil
        redirect_to admin_titles_path }
    end
  end

  def destroy
    @title = Title.find(params[:id])
    render :js => mtr_toast("刪除失敗") and return if not @title.destroy
  end
  
private

  def title_params
    params.require(:title).permit(:title)
  end
  def titles_params
    params.require(:title_ids)
  end
end
