jQuery(document).ready ($) ->
  $toastContent = $('<span>更新成功</span>')
  Materialize.toast $toastContent, 5000
  return