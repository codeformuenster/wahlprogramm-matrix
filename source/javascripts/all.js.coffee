#= require jquery
#= require_tree .
#= require_self

scrollToParagraph = (elem) ->
  $(elem).closest('.scroll-container').animate({
    scrollTop: $(elem).position().top
    }, 500)

$(document).on 'click', '[data-click]', ->
  $wrapper = $('#wrapper')
  if $wrapper.hasClass($(@).data('click'))
    $wrapper.removeClass()
  else
    $wrapper.removeClass().addClass($(@).data('click')).addClass('selected')
  $(@).data('closest').forEach scrollToParagraph
  window.location.hash = "#" + [$(@).attr('id')].concat($(@).data('closest').map((id) -> id.substr(1))).join('+')
  
$ ->
  # scrolling indicators
  $('.scroll-container').on 'scroll', ->
    scrollIndicator = $(@).closest('.sub-container').prev().find('.scroll-indicator') # FIXME ugly
    contentHeight = $(@).find('.wrapper').height()
    scrollPercentage = $(@).scrollTop()/contentHeight*100
    barHeightPercentage = $(@).height()/contentHeight*100
    scrollIndicator.css(top: "#{scrollPercentage - scrollPercentage*barHeightPercentage/100}%", height: "#{barHeightPercentage}%", "min-height": "10px")
  $('.scroll-container').trigger('scroll')
  # hide scrollbars
  $('.scroll-container').css("margin-right": -> @clientWidth - @offsetWidth - 1)

  # fix minimap heights
  $('.doc').each ->
    contentHeight = $(@).closest('.wrapper').height()
    $("[href='##{$(@).attr('id')}']").css(height: "#{$(@).height()/contentHeight*100}%")

  $('.minimap a').tipsy(title: 'data-important', gravity: 'w')

  # animate jump to paragraph
  $('.scroll-container .wrapper').css(position: 'relative') # set offsetParent

  $('a.jump-to-paragraph').click((e) ->
    e.preventDefault()
    scrollToParagraph($(@).data('target'))
    window.location.hash = $(@).data('target')
    # TODO scroll other parties max dist
  )

  $(window).on('hashchange', (e) ->
    elements = window.location.hash[1..].split('+').map (e) -> "##{e}"
    elements.forEach scrollToParagraph
    )

# scrollcontainer top
$ ->

$ ->
  # help
  help = $('#help')
  close = $('#close')
  retract = -> help.removeClass('expanded')
  expand = -> help.addClass('expanded')
  toggle = -> help.toggleClass('expanded')
  firstRetraction = 10 # 10*1000
  timer = setTimeout(retract, firstRetraction)
  cancelFirstRetraction = -> clearTimeout(timer)
  help.on 'mouseenter', -> expand(); cancelFirstRetraction()
  help.on 'mouseleave', retract
  close.on 'click', toggle
