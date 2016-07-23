jQuery(document).ready ($) ->
  $(  '#view_category_<%= @category.id %>').html('已刪除').addClass 'delete-text'
  $('#delete_category_<%= @category.id %>')              .addClass 'delete-text'

  $(    '#li_category_<%= @category.id %>')              .addClass 'point-disabled'

  $toastContent = $('<span>刪除成功</span>')
  Materialize.toast $toastContent, 5000
  return
