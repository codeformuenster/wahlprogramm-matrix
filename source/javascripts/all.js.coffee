#= require jquery
#= require_tree .
#= require_self

$(document).on 'click', '[data-click]', ->
  $('#container').removeClass().addClass($(@).data('click'))

$ ->
  $('.sub-container').on 'scroll', ->
    scrollIndicator = $(@).prev().find('.scroll-indicator')
    contentHeight = $(@).find('.wrapper').height()
    scrollPercentage = $(@).scrollTop()/contentHeight*100
    barHeightPercentage = $(this).height()/contentHeight*100
    scrollIndicator.css(top: "#{scrollPercentage - scrollPercentage*barHeightPercentage/100}%", height: "#{barHeightPercentage}%")
  $('.sub-container').trigger('scroll')

  # fix minimap heights
  $('.doc').each ->
    contentHeight = $(@).closest('.wrapper').height()
    $("[href='##{$(@).attr('id')}']").css(height: "#{$(@).height()/contentHeight*100}%")

  $('.minimap a').tipsy(title: 'data-important', gravity: 'w')
