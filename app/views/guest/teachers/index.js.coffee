jQuery(document).ready ($) ->
  $('#teachers').html("<%= escape_javascript(render @teachers) %>")
  return