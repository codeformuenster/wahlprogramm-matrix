#= require jquery
#= require_tree .
#= require_self

$(document).on 'click', '[data-click]', ->
  $container = $('#container')
  if $container.hasClass($(@).data('click'))
    $container.removeClass()
  else
    $container.removeClass().addClass($(@).data('click')).addClass('selected')

$ ->
  # scrolling indicators
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

$ ->
  # help
  help = $('#help')
  close = $('#close')
  retract = -> help.removeClass('expanded')
  expand = -> help.addClass('expanded')
  toggle = -> help.toggleClass('expanded')
  firstRetraction = 10*1000
  timer = setTimeout(retract, firstRetraction)
  cancelFirstRetraction = -> clearTimeout(timer)
  expand()
  help.on 'mouseenter', -> expand(); cancelFirstRetraction()
  help.on 'mouseleave', retract
  close.on 'click', toggle
