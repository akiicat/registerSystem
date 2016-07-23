jQuery(document).ready ($) ->
  $(  '#view_title_<%= @title.id %>').html('已刪除').addClass 'delete-text'
  $('#delete_title_<%= @title.id %>')              .addClass 'delete-text'

  $(    '#li_title_<%= @title.id %>')              .addClass 'point-disabled'

  $toastContent = $('<span>刪除成功</span>')
  Materialize.toast $toastContent, 5000
  return
