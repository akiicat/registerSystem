jQuery(document).ready ($) ->
  $('<%= escape_javascript(render @category) %>').appendTo '#tbody_category'

  $toastContent = $('<span>新增成功</span>')
  Materialize.toast $toastContent, 5000
  return