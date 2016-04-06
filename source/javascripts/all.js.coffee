#= require jquery
#= require_tree .
#= require_self

scrollToTool = () ->
  return if $('body').scrollTop() == $('#container').position().top
  $('body').animate({
    scrollTop: $('#container').position().top
    }, 500)

scrollToParagraph = (elem) ->
  $(elem).closest('.scroll-container').animate({
    scrollTop: $(elem).position().top
    }, 500)

parseHash = ->
  return unless window.location.hash
  elements = window.location.hash[1..].split('+').map (e) -> "##{e}"
  if elements.length
    scrollToTool()
    elements.forEach scrollToParagraph
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

$(document).on 'click', '[data-click]', (e) ->
  e.preventDefault()
  scrollToTool()
  activateParagraph(@)
  scrollToClosest(@)

$ ->
  # scrolling indicators
  $('.scroll-container').on 'scroll', ->
    console.log('scroll')
    $(@).closest('.sub-container').find('.sub-container-title-bar').toggleClass('active', $(@).scrollTop() > 20)
    scrollIndicator = $(@).closest('.sub-container').find('.scroll-indicator')
    return if scrollIndicator.hasClass('dragging')
    contentHeight = $(@).find('.wrapper').height()
    scrollPercentage = $(@).scrollTop()/contentHeight*100
    barHeightPercentage = $(@).height()/contentHeight*100
    scrollIndicator.css(top: "#{scrollPercentage - scrollPercentage*barHeightPercentage/100}%", height: "#{barHeightPercentage}%", "min-height": "10px")
  $('.scroll-container').trigger('scroll')
  # hide scrollbars
  $('.scroll-container').css("margin-right", -> @clientWidth - @offsetWidth - 1)

  dragImage = document.createElement('img')
  dragImage.src = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==';

  $('.scroll-indicator').on 'dragstart', (e) ->
    e.originalEvent.dataTransfer.setDragImage(dragImage, 0, 0)
    $(@).toggleClass('dragging', true)

  $('.scroll-indicator').on 'drag', (e) ->
    return if e.originalEvent.screenY == 0
    scrollbarHeight = $(@).closest('.minimap').height()
    handleTop = $(@).position().top
    handleHeight = $(@).height()
    maxTop = scrollbarHeight# - handleHeight
    minTop = 0
    relativeY = e.originalEvent.offsetY
    scrollPercentage = Math.max(0, Math.min(handleTop+relativeY, maxTop))/scrollbarHeight*100
    $(@).css(top: "#{scrollPercentage}%")
    scrollcontainer = $(@).closest('.sub-container').find('.scroll-container')
    contentHeight = $(scrollcontainer).find('.wrapper').height()
    scrollcontainer.scrollTop(scrollPercentage/100*contentHeight)

  $('.scroll-indicator').on 'dragend', ->
    $(@).toggleClass('dragging', false)



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
