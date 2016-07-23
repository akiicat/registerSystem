jQuery(document).ready ($) ->
  $('<%= escape_javascript(render @title) %>').appendTo '#tbody_title'

  $toastContent = $('<span>新增成功</span>')
  Materialize.toast $toastContent, 5000
  return