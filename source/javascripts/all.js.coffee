#= require jquery
#= require_tree .
#= require_self

scrollToParagraph = (elem) ->
  $(elem).closest('.scroll-container').animate({
    scrollTop: $(elem).position().top
    }, 500)

parseHash = ->
  return unless window.location.hash
  elements = window.location.hash[1..].split('+').map (e) -> "##{e}"
  elements.forEach scrollToParagraph
  if elements.length
    activateParagraph(elements[0])

activateParagraph = (p) ->
  $wrapper = $('#wrapper')
  if $wrapper.hasClass($(p).data('click'))
    $wrapper.removeClass()
  else
    $wrapper.removeClass().addClass($(p).data('click')).addClass('selected')

scrollToClosest = (p) ->
  $(p).data('closest').forEach scrollToParagraph
  history.pushState({}, '', "/#" + [$(p).attr('id')].concat($(p).data('closest').map((id) -> id.substr(1))).join('+'))

$(document).on 'click', '[data-click]', ->
  activateParagraph(@)
  scrollToClosest(@)

$ ->
  # scrolling indicators
  $('.scroll-container').on 'scroll', ->
    $(@).closest('.sub-container').find('.sub-container-title-bar').toggleClass('active', $(@).scrollTop() > 20)
    scrollIndicator = $(@).closest('.sub-container').find('.scroll-indicator') # FIXME ugly
    contentHeight = $(@).find('.wrapper').height()
    scrollPercentage = $(@).scrollTop()/contentHeight*100
    barHeightPercentage = $(@).height()/contentHeight*100
    scrollIndicator.css(top: "#{scrollPercentage - scrollPercentage*barHeightPercentage/100}%", height: "#{barHeightPercentage}%", "min-height": "10px")
  $('.scroll-container').trigger('scroll')
  # hide scrollbars
  $('.scroll-container').css("margin-right", -> @clientWidth - @offsetWidth - 1)

  # fix minimap heights
  $('.doc').each ->
    contentHeight = $(@).closest('.wrapper').height()
    $("[href='##{$(@).attr('id')}']").css(height: "#{$(@).height()/contentHeight*100}%")

  $('.minimap a').tipsy(title: 'data-important', gravity: 'e')

  # animate jump to paragraph
  $('.scroll-container .wrapper').css(position: 'relative') # set offsetParent

  $('a.jump-to-paragraph').click((e) ->
    e.preventDefault()
    scrollToParagraph($(@).data('target'))
    history.pushState({}, '', '/'+$(@).data('target'))
    # TODO scroll other parties max dist
  )

  $(window).on('hashchange', (e) ->
    console.log "onhashchange"
    parseHash()
    e.preventDefault()
    )
  parseHash()

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
