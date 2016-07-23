jQuery(document).ready ($) ->
  $("#ul_group").append('<%= j render(@group)%>');

  $toastContent = $('<span>新增成功</span>')
  Materialize.toast $toastContent, 5000
  return