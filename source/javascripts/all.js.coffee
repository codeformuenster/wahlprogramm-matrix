#= require jquery
#= require_tree .
#= require_self

$(document).on 'click', '[data-click]', ->
  $('#container').removeClass().addClass($(@).data('click'))

$ ->
  $('.sub-container').on 'scroll', ->
    contentHeight = $(@).find('.wrapper').height()
    scrollPercentage = $(@).scrollTop()/contentHeight*100
    barHeightPercentage = $(this).height()/contentHeight*100
    console.log scrollPercentage, barHeightPercentage
    $(@).prev().find('.scroll-indicator').css(top: "#{scrollPercentage}%", height: "#{barHeightPercentage}%")
  $('.sub-container').trigger('scroll')
