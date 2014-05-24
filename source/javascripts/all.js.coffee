#= require jquery
#= require_tree .
#= require_self

$(document).on 'click', '[data-click]', ->
  $('#container').removeClass().addClass($(@).data('click'))

$ ->
  $('.sub-container').on 'scroll', ->
    scrollIndicator = $(@).prev().find('.scroll-indicator')
    contentHeight = $(@).find('.wrapper').height()
    scrollPercentage = 1.0*$(@).scrollTop()/contentHeight*100
    barHeightPercentage = 1.0*$(this).height()/contentHeight*100
    scrollIndicator.css(top: "#{scrollPercentage}%", height: "#{barHeightPercentage}%")
  $('.sub-container').trigger('scroll')
