#= require jquery
#= require_tree .
#= require_self

$(document).on 'click', '[data-click]', ->
  $('#container').removeClass().addClass($(@).data('click'))
