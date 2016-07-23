jQuery(document).ready ($) ->
  $('#view_group_<%= @group.id %>').html('已刪除').addClass 'delete-text'
  $('#delete_group_<%= @group.id %>').addClass 'delete-text'

  $('#li_group_<%= @group.id %>').addClass 'point-disabled'

  $toastContent = $('<span>刪除成功</span>')
  Materialize.toast $toastContent, 5000
  return
