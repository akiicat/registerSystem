class Admin::GroupsController < Admin::ApplicationController
  layout "admin"

  def index
    @page_title = '組別' + NCTUEE_TITLE
    @groups = Group.all
    @group = Group.new
  end

  def edit
    @page_title = '編輯組別' + NCTUEE_TITLE
    @groups = Group.all
  end

  def create
    @group = Group.new(group_params)
    unless @group.save
      render :js => mtr_toast("新增失敗") and return
    end
  end
  
  def update
    unless Group.update(groups_params.keys, groups_params.values)
      render :js => mtr_toast("更新失敗") and return
    end
  end

  def destroy
    @group = Group.find(params[:id])
    unless @group.destroy
      render :js => mtr_toast("刪除失敗") and return
    end
  end
  
private

  def group_params
    params.require(:group).permit(:group)
  end
  def groups_params
    params.require(:group_ids)
  end
end
