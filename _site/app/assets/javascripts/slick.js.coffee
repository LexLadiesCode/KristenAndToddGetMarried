#
#     _ _      _       _
# ___| (_) ___| | __  (_)___
#/ __| | |/ __| |/ /  | / __|
#\__ \ | | (__|   < _ | \__ \
#|___/_|_|\___|_|\_(_)/ |___/
#                   |__/
#
# Version: 1.3.6
#  Author: Ken Wheeler
# Website: http://kenwheeler.github.io
#    Docs: http://kenwheeler.github.io/slick
#    Repo: http://github.com/kenwheeler/slick
#  Issues: http://github.com/kenwheeler/slick/issues
#
# 

# global window, document, define, jQuery, setInterval, clearInterval 
((factory) ->
  "use strict"
  if typeof define is "function" and define.amd
    define ["jquery"], factory
  else
    factory jQuery
  return
) ($) ->
  "use strict"
  Slick = window.Slick or {}
  Slick = (->
    Slick = (element, settings) ->
      _ = this
      responsiveSettings = undefined
      breakpoint = undefined
      _.defaults =
        accessibility: true
        appendArrows: $(element)
        arrows: true
        asNavFor: null
        prevArrow: "<button type=\"button\" class=\"slick-prev\">Previous</button>"
        nextArrow: "<button type=\"button\" class=\"slick-next\">Next</button>"
        autoplay: false
        autoplaySpeed: 3000
        centerMode: false
        centerPadding: "50px"
        cssEase: "ease"
        customPaging: (slider, i) ->
          "<button type=\"button\">" + (i + 1) + "</button>"

        dots: false
        draggable: true
        easing: "linear"
        fade: false
        focusOnSelect: false
        infinite: true
        lazyLoad: "ondemand"
        onBeforeChange: null
        onAfterChange: null
        onInit: null
        onReInit: null
        pauseOnHover: true
        pauseOnDotsHover: false
        responsive: null
        slide: "div"
        slidesToShow: 1
        slidesToScroll: 1
        speed: 300
        swipe: true
        touchMove: true
        touchThreshold: 5
        useCSS: true
        vertical: false

      _.initials =
        animating: false
        dragging: false
        autoPlayTimer: null
        currentSlide: 0
        currentLeft: null
        direction: 1
        $dots: null
        listWidth: null
        listHeight: null
        loadIndex: 0
        $nextArrow: null
        $prevArrow: null
        slideCount: null
        slideWidth: null
        $slideTrack: null
        $slides: null
        sliding: false
        slideOffset: 0
        swipeLeft: null
        $list: null
        touchObject: {}
        transformsEnabled: false

      $.extend _, _.initials
      _.activeBreakpoint = null
      _.animType = null
      _.animProp = null
      _.breakpoints = []
      _.breakpointSettings = []
      _.cssTransitions = false
      _.paused = false
      _.positionProp = null
      _.$slider = $(element)
      _.$slidesCache = null
      _.transformType = null
      _.transitionType = null
      _.windowWidth = 0
      _.windowTimer = null
      _.options = $.extend({}, _.defaults, settings)
      _.originalSettings = _.options
      responsiveSettings = _.options.responsive or null
      if responsiveSettings and responsiveSettings.length > -1
        for breakpoint of responsiveSettings
          if responsiveSettings.hasOwnProperty(breakpoint)
            _.breakpoints.push responsiveSettings[breakpoint].breakpoint
            _.breakpointSettings[responsiveSettings[breakpoint].breakpoint] = responsiveSettings[breakpoint].settings
        _.breakpoints.sort (a, b) ->
          b - a

      _.autoPlay = $.proxy(_.autoPlay, _)
      _.autoPlayClear = $.proxy(_.autoPlayClear, _)
      _.changeSlide = $.proxy(_.changeSlide, _)
      _.selectHandler = $.proxy(_.selectHandler, _)
      _.setPosition = $.proxy(_.setPosition, _)
      _.swipeHandler = $.proxy(_.swipeHandler, _)
      _.dragHandler = $.proxy(_.dragHandler, _)
      _.keyHandler = $.proxy(_.keyHandler, _)
      _.autoPlayIterator = $.proxy(_.autoPlayIterator, _)
      _.instanceUid = instanceUid++
      
      # A simple way to check for HTML strings
      # Strict HTML recognition (must start with <)
      # Extracted from jQuery v1.11 source
      _.htmlExpr = /^(?:\s*(<[\w\W]+>)[^>]*)$/
      _.init()
      return
    instanceUid = 0
    Slick
  )
  Slick::addSlide = (markup, index, addBefore) ->
    _ = this
    if typeof (index) is "boolean"
      addBefore = index
      index = null
    else return false  if index < 0 or (index >= _.slideCount)
    _.unload()
    if typeof (index) is "number"
      if index is 0 and _.$slides.length is 0
        $(markup).appendTo _.$slideTrack
      else if addBefore
        $(markup).insertBefore _.$slides.eq(index)
      else
        $(markup).insertAfter _.$slides.eq(index)
    else
      if addBefore is true
        $(markup).prependTo _.$slideTrack
      else
        $(markup).appendTo _.$slideTrack
    _.$slides = _.$slideTrack.children(@options.slide)
    _.$slideTrack.children(@options.slide).remove()
    _.$slideTrack.append _.$slides
    _.$slides.each (index, element) ->
      $(element).attr "index", index
      return

    _.$slidesCache = _.$slides
    _.reinit()
    return

  Slick::animateSlide = (targetLeft, callback) ->
    animProps = {}
    _ = this
    if _.transformsEnabled is false
      if _.options.vertical is false
        _.$slideTrack.animate
          left: targetLeft
        , _.options.speed, _.options.easing, callback
      else
        _.$slideTrack.animate
          top: targetLeft
        , _.options.speed, _.options.easing, callback
    else
      if _.cssTransitions is false
        $(animStart: _.currentLeft).animate
          animStart: targetLeft
        ,
          duration: _.options.speed
          easing: _.options.easing
          step: (now) ->
            if _.options.vertical is false
              animProps[_.animType] = "translate(" + now + "px, 0px)"
              _.$slideTrack.css animProps
            else
              animProps[_.animType] = "translate(0px," + now + "px)"
              _.$slideTrack.css animProps
            return

          complete: ->
            callback.call()  if callback
            return

      else
        _.applyTransition()
        if _.options.vertical is false
          animProps[_.animType] = "translate3d(" + targetLeft + "px, 0px, 0px)"
        else
          animProps[_.animType] = "translate3d(0px," + targetLeft + "px, 0px)"
        _.$slideTrack.css animProps
        if callback
          setTimeout (->
            _.disableTransition()
            callback.call()
            return
          ), _.options.speed
    return

  Slick::applyTransition = (slide) ->
    _ = this
    transition = {}
    if _.options.fade is false
      transition[_.transitionType] = _.transformType + " " + _.options.speed + "ms " + _.options.cssEase
    else
      transition[_.transitionType] = "opacity " + _.options.speed + "ms " + _.options.cssEase
    if _.options.fade is false
      _.$slideTrack.css transition
    else
      _.$slides.eq(slide).css transition
    return

  Slick::autoPlay = ->
    _ = this
    clearInterval _.autoPlayTimer  if _.autoPlayTimer
    _.autoPlayTimer = setInterval(_.autoPlayIterator, _.options.autoplaySpeed)  if _.slideCount > _.options.slidesToShow and _.paused isnt true
    return

  Slick::autoPlayClear = ->
    _ = this
    clearInterval _.autoPlayTimer  if _.autoPlayTimer
    return

  Slick::autoPlayIterator = ->
    _ = this
    asNavFor = (if _.options.asNavFor? then $(_.options.asNavFor).getSlick() else null)
    if _.options.infinite is false
      if _.direction is 1
        _.direction = 0  if (_.currentSlide + 1) is _.slideCount - 1
        _.slideHandler _.currentSlide + _.options.slidesToScroll
        asNavFor.slideHandler asNavFor.currentSlide + asNavFor.options.slidesToScroll  if asNavFor?
      else
        _.direction = 1  if _.currentSlide - 1 is 0
        _.slideHandler _.currentSlide - _.options.slidesToScroll
        asNavFor.slideHandler asNavFor.currentSlide - asNavFor.options.slidesToScroll  if asNavFor?
    else
      _.slideHandler _.currentSlide + _.options.slidesToScroll
      asNavFor.slideHandler asNavFor.currentSlide + asNavFor.options.slidesToScroll  if asNavFor?
    return

  Slick::buildArrows = ->
    _ = this
    if _.options.arrows is true and _.slideCount > _.options.slidesToShow
      _.$prevArrow = $(_.options.prevArrow)
      _.$nextArrow = $(_.options.nextArrow)
      _.$prevArrow.appendTo _.options.appendArrows  if _.htmlExpr.test(_.options.prevArrow)
      _.$nextArrow.appendTo _.options.appendArrows  if _.htmlExpr.test(_.options.nextArrow)
      _.$prevArrow.addClass "slick-disabled"  if _.options.infinite isnt true
    return

  Slick::buildDots = ->
    _ = this
    i = undefined
    dotString = undefined
    if _.options.dots is true and _.slideCount > _.options.slidesToShow
      dotString = "<ul class=\"slick-dots\">"
      i = 0
      while i <= _.getDotCount()
        dotString += "<li>" + _.options.customPaging.call(this, _, i) + "</li>"
        i += 1
      dotString += "</ul>"
      _.$dots = $(dotString).appendTo(_.$slider)
      _.$dots.find("li").first().addClass "slick-active"
    return

  Slick::buildOut = ->
    _ = this
    _.$slides = _.$slider.children(_.options.slide + ":not(.slick-cloned)").addClass("slick-slide")
    _.slideCount = _.$slides.length
    _.$slides.each (index, element) ->
      $(element).attr "index", index
      return

    _.$slidesCache = _.$slides
    _.$slider.addClass "slick-slider"
    _.$slideTrack = (if (_.slideCount is 0) then $("<div class=\"slick-track\"/>").appendTo(_.$slider) else _.$slides.wrapAll("<div class=\"slick-track\"/>").parent())
    _.$list = _.$slideTrack.wrap("<div class=\"slick-list\"/>").parent()
    _.$slideTrack.css "opacity", 0
    if _.options.centerMode is true
      _.options.slidesToScroll = 1
      _.options.slidesToShow = 3  if _.options.slidesToShow % 2 is 0
    $("img[data-lazy]", _.$slider).not("[src]").addClass "slick-loading"
    _.setupInfinite()
    _.buildArrows()
    _.buildDots()
    _.updateDots()
    _.$list.prop "tabIndex", 0  if _.options.accessibility is true
    _.setSlideClasses (if typeof @currentSlide is "number" then @currentSlide else 0)
    _.$list.addClass "draggable"  if _.options.draggable is true
    return

  Slick::checkResponsive = ->
    _ = this
    breakpoint = undefined
    targetBreakpoint = undefined
    if _.originalSettings.responsive and _.originalSettings.responsive.length > -1 and _.originalSettings.responsive isnt null
      targetBreakpoint = null
      for breakpoint of _.breakpoints
        targetBreakpoint = _.breakpoints[breakpoint]  if $(window).width() < _.breakpoints[breakpoint]  if _.breakpoints.hasOwnProperty(breakpoint)
      if targetBreakpoint isnt null
        if _.activeBreakpoint isnt null
          if targetBreakpoint isnt _.activeBreakpoint
            _.activeBreakpoint = targetBreakpoint
            _.options = $.extend({}, _.options, _.breakpointSettings[targetBreakpoint])
            _.refresh()
        else
          _.activeBreakpoint = targetBreakpoint
          _.options = $.extend({}, _.options, _.breakpointSettings[targetBreakpoint])
          _.refresh()
      else
        if _.activeBreakpoint isnt null
          _.activeBreakpoint = null
          _.options = $.extend({}, _.options, _.originalSettings)
          _.refresh()
    return

  Slick::changeSlide = (event) ->
    _ = this
    $target = $(event.target)
    asNavFor = (if _.options.asNavFor? then $(_.options.asNavFor).getSlick() else null)
    
    # If target is a link, prevent default action.
    $target.is("a") and event.preventDefault()
    switch event.data.message
      when "previous"
        if _.slideCount > _.options.slidesToShow
          _.slideHandler _.currentSlide - _.options.slidesToScroll
          asNavFor.slideHandler asNavFor.currentSlide - asNavFor.options.slidesToScroll  if asNavFor?
      when "next"
        if _.slideCount > _.options.slidesToShow
          _.slideHandler _.currentSlide + _.options.slidesToScroll
          asNavFor.slideHandler asNavFor.currentSlide + asNavFor.options.slidesToScroll  if asNavFor?
      when "index"
        index = $(event.target).parent().index() * _.options.slidesToScroll
        _.slideHandler index
        asNavFor.slideHandler index  if asNavFor?
      else
        false

  Slick::destroy = ->
    _ = this
    _.autoPlayClear()
    _.touchObject = {}
    $(".slick-cloned", _.$slider).remove()
    _.$dots.remove()  if _.$dots
    if _.$prevArrow
      _.$prevArrow.remove()
      _.$nextArrow.remove()
    _.$slides.unwrap().unwrap()  if _.$slides.parent().hasClass("slick-track")
    _.$slides.removeClass("slick-slide slick-active slick-visible").removeAttr "style"
    _.$slider.removeClass "slick-slider"
    _.$slider.removeClass "slick-initialized"
    _.$list.off ".slick"
    $(window).off ".slick-" + _.instanceUid
    return

  Slick::disableTransition = (slide) ->
    _ = this
    transition = {}
    transition[_.transitionType] = ""
    if _.options.fade is false
      _.$slideTrack.css transition
    else
      _.$slides.eq(slide).css transition
    return

  Slick::fadeSlide = (slideIndex, callback) ->
    _ = this
    if _.cssTransitions is false
      _.$slides.eq(slideIndex).css zIndex: 1000
      _.$slides.eq(slideIndex).animate
        opacity: 1
      , _.options.speed, _.options.easing, callback
    else
      _.applyTransition slideIndex
      _.$slides.eq(slideIndex).css
        opacity: 1
        zIndex: 1000

      if callback
        setTimeout (->
          _.disableTransition slideIndex
          callback.call()
          return
        ), _.options.speed
    return

  Slick::filterSlides = (filter) ->
    _ = this
    if filter isnt null
      _.unload()
      _.$slideTrack.children(@options.slide).remove()
      _.$slidesCache.filter(filter).appendTo _.$slideTrack
      _.reinit()
    return

  Slick::getCurrent = ->
    _ = this
    _.currentSlide

  Slick::getDotCount = ->
    _ = this
    breaker = 0
    dotCounter = 0
    dotCount = 0
    dotLimit = undefined
    dotLimit = (if _.options.infinite is true then _.slideCount + _.options.slidesToShow - _.options.slidesToScroll else _.slideCount)
    while breaker < dotLimit
      dotCount++
      dotCounter += _.options.slidesToScroll
      breaker = dotCounter + _.options.slidesToShow
    dotCount

  Slick::getLeft = (slideIndex) ->
    _ = this
    targetLeft = undefined
    verticalHeight = undefined
    verticalOffset = 0
    _.slideOffset = 0
    verticalHeight = _.$slides.first().outerHeight()
    if _.options.infinite is true
      if _.slideCount > _.options.slidesToShow
        _.slideOffset = (_.slideWidth * _.options.slidesToShow) * -1
        verticalOffset = (verticalHeight * _.options.slidesToShow) * -1
      if _.slideCount % _.options.slidesToScroll isnt 0
        if slideIndex + _.options.slidesToScroll > _.slideCount and _.slideCount > _.options.slidesToShow
          _.slideOffset = ((_.slideCount % _.options.slidesToShow) * _.slideWidth) * -1
          verticalOffset = ((_.slideCount % _.options.slidesToShow) * verticalHeight) * -1
    else
      if _.slideCount % _.options.slidesToShow isnt 0
        if slideIndex + _.options.slidesToScroll > _.slideCount and _.slideCount > _.options.slidesToShow
          _.slideOffset = (_.options.slidesToShow * _.slideWidth) - ((_.slideCount % _.options.slidesToShow) * _.slideWidth)
          verticalOffset = ((_.slideCount % _.options.slidesToShow) * verticalHeight)
    if _.options.centerMode is true and _.options.infinite is true
      _.slideOffset += _.slideWidth * Math.floor(_.options.slidesToShow / 2) - _.slideWidth
    else _.slideOffset += _.slideWidth * Math.floor(_.options.slidesToShow / 2)  if _.options.centerMode is true
    if _.options.vertical is false
      targetLeft = ((slideIndex * _.slideWidth) * -1) + _.slideOffset
    else
      targetLeft = ((slideIndex * verticalHeight) * -1) + verticalOffset
    targetLeft

  Slick::init = ->
    _ = this
    unless $(_.$slider).hasClass("slick-initialized")
      $(_.$slider).addClass "slick-initialized"
      _.buildOut()
      _.setProps()
      _.startLoad()
      _.loadSlider()
      _.initializeEvents()
      _.checkResponsive()
    _.options.onInit.call this, _  if _.options.onInit isnt null
    return

  Slick::initArrowEvents = ->
    _ = this
    if _.options.arrows is true and _.slideCount > _.options.slidesToShow
      _.$prevArrow.on "click.slick",
        message: "previous"
      , _.changeSlide
      _.$nextArrow.on "click.slick",
        message: "next"
      , _.changeSlide
    return

  Slick::initDotEvents = ->
    _ = this
    if _.options.dots is true and _.slideCount > _.options.slidesToShow
      $("li", _.$dots).on "click.slick",
        message: "index"
      , _.changeSlide
    $("li", _.$dots).on("mouseenter.slick", _.autoPlayClear).on "mouseleave.slick", _.autoPlay  if _.options.dots is true and _.options.pauseOnDotsHover is true and _.options.autoplay is true
    return

  Slick::initializeEvents = ->
    _ = this
    _.initArrowEvents()
    _.initDotEvents()
    _.$list.on "touchstart.slick mousedown.slick",
      action: "start"
    , _.swipeHandler
    _.$list.on "touchmove.slick mousemove.slick",
      action: "move"
    , _.swipeHandler
    _.$list.on "touchend.slick mouseup.slick",
      action: "end"
    , _.swipeHandler
    _.$list.on "touchcancel.slick mouseleave.slick",
      action: "end"
    , _.swipeHandler
    if _.options.pauseOnHover is true and _.options.autoplay is true
      _.$list.on "mouseenter.slick", _.autoPlayClear
      _.$list.on "mouseleave.slick", _.autoPlay
    _.$list.on "keydown.slick", _.keyHandler  if _.options.accessibility is true
    $(_.options.slide, _.$slideTrack).on "click.slick", _.selectHandler  if _.options.focusOnSelect is true
    $(window).on "orientationchange.slick.slick-" + _.instanceUid, ->
      _.checkResponsive()
      _.setPosition()
      return

    $(window).on "resize.slick.slick-" + _.instanceUid, ->
      if $(window).width isnt _.windowWidth
        clearTimeout _.windowDelay
        _.windowDelay = window.setTimeout(->
          _.windowWidth = $(window).width()
          _.checkResponsive()
          _.setPosition()
          return
        , 50)
      return

    $(window).on "load.slick.slick-" + _.instanceUid, _.setPosition
    $(document).on "ready.slick.slick-" + _.instanceUid, _.setPosition
    return

  Slick::initUI = ->
    _ = this
    if _.options.arrows is true and _.slideCount > _.options.slidesToShow
      _.$prevArrow.show()
      _.$nextArrow.show()
    _.$dots.show()  if _.options.dots is true and _.slideCount > _.options.slidesToShow
    _.autoPlay()  if _.options.autoplay is true
    return

  Slick::keyHandler = (event) ->
    _ = this
    if event.keyCode is 37
      _.changeSlide data:
        message: "previous"

    else if event.keyCode is 39
      _.changeSlide data:
        message: "next"

    return

  Slick::lazyLoad = ->
    loadImages = (imagesScope) ->
      $("img[data-lazy]", imagesScope).each ->
        image = $(this)
        imageSource = $(this).attr("data-lazy")
        image.css(opacity: 0).attr("src", imageSource).removeAttr("data-lazy").removeClass("slick-loading").load ->
          image.animate
            opacity: 1
          , 200
          return

        return

      return
    _ = this
    loadRange = undefined
    cloneRange = undefined
    rangeStart = undefined
    rangeEnd = undefined
    if _.options.centerMode is true or _.options.fade is true
      rangeStart = _.options.slidesToShow + _.currentSlide - 1
      rangeEnd = rangeStart + _.options.slidesToShow + 2
    else
      rangeStart = (if _.options.infinite then _.options.slidesToShow + _.currentSlide else _.currentSlide)
      rangeEnd = rangeStart + _.options.slidesToShow
    loadRange = _.$slider.find(".slick-slide").slice(rangeStart, rangeEnd)
    loadImages loadRange
    if _.currentSlide >= _.slideCount - _.options.slidesToShow
      cloneRange = _.$slider.find(".slick-cloned").slice(0, _.options.slidesToShow)
      loadImages cloneRange
    else if _.currentSlide is 0
      cloneRange = _.$slider.find(".slick-cloned").slice(_.options.slidesToShow * -1)
      loadImages cloneRange
    return

  Slick::loadSlider = ->
    _ = this
    _.setPosition()
    _.$slideTrack.css opacity: 1
    _.$slider.removeClass "slick-loading"
    _.initUI()
    _.progressiveLazyLoad()  if _.options.lazyLoad is "progressive"
    return

  Slick::postSlide = (index) ->
    _ = this
    _.options.onAfterChange.call this, _, index  if _.options.onAfterChange isnt null
    _.animating = false
    _.setPosition()
    _.swipeLeft = null
    _.autoPlay()  if _.options.autoplay is true and _.paused is false
    return

  Slick::progressiveLazyLoad = ->
    _ = this
    imgCount = undefined
    targetImage = undefined
    imgCount = $("img[data-lazy]").length
    if imgCount > 0
      targetImage = $("img[data-lazy]", _.$slider).first()
      targetImage.attr("src", targetImage.attr("data-lazy")).removeClass("slick-loading").load ->
        targetImage.removeAttr "data-lazy"
        _.progressiveLazyLoad()
        return

    return

  Slick::refresh = ->
    _ = this
    currentSlide = _.currentSlide
    _.destroy()
    $.extend _, _.initials
    _.currentSlide = currentSlide
    _.init()
    return

  Slick::reinit = ->
    _ = this
    _.$slides = _.$slideTrack.children(_.options.slide).addClass("slick-slide")
    _.slideCount = _.$slides.length
    _.currentSlide = _.currentSlide - _.options.slidesToScroll  if _.currentSlide >= _.slideCount and _.currentSlide isnt 0
    _.setProps()
    _.setupInfinite()
    _.buildArrows()
    _.updateArrows()
    _.initArrowEvents()
    _.buildDots()
    _.updateDots()
    _.initDotEvents()
    $(_.options.slide, _.$slideTrack).on "click.slick", _.selectHandler  if _.options.focusOnSelect is true
    _.setSlideClasses 0
    _.setPosition()
    _.options.onReInit.call this, _  if _.options.onReInit isnt null
    return

  Slick::removeSlide = (index, removeBefore) ->
    _ = this
    if typeof (index) is "boolean"
      removeBefore = index
      index = (if removeBefore is true then 0 else _.slideCount - 1)
    else
      index = (if removeBefore is true then --index else index)
    return false  if _.slideCount < 1 or index < 0 or index > _.slideCount - 1
    _.unload()
    _.$slideTrack.children(@options.slide).eq(index).remove()
    _.$slides = _.$slideTrack.children(@options.slide)
    _.$slideTrack.children(@options.slide).remove()
    _.$slideTrack.append _.$slides
    _.$slidesCache = _.$slides
    _.reinit()
    return

  Slick::setCSS = (position) ->
    _ = this
    positionProps = {}
    x = undefined
    y = undefined
    x = (if _.positionProp is "left" then position + "px" else "0px")
    y = (if _.positionProp is "top" then position + "px" else "0px")
    positionProps[_.positionProp] = position
    if _.transformsEnabled is false
      _.$slideTrack.css positionProps
    else
      positionProps = {}
      if _.cssTransitions is false
        positionProps[_.animType] = "translate(" + x + ", " + y + ")"
        _.$slideTrack.css positionProps
      else
        positionProps[_.animType] = "translate3d(" + x + ", " + y + ", 0px)"
        _.$slideTrack.css positionProps
    return

  Slick::setDimensions = ->
    _ = this
    if _.options.centerMode is true
      _.$slideTrack.children(".slick-slide").width _.slideWidth
    else
      _.$slideTrack.children(".slick-slide").width _.slideWidth
    if _.options.vertical is false
      _.$slideTrack.width Math.ceil((_.slideWidth * _.$slideTrack.children(".slick-slide").length))
      _.$list.css padding: ("0px " + _.options.centerPadding)  if _.options.centerMode is true
    else
      _.$list.height _.$slides.first().outerHeight() * _.options.slidesToShow
      _.$slideTrack.height Math.ceil((_.$slides.first().outerHeight() * _.$slideTrack.children(".slick-slide").length))
      _.$list.css padding: (_.options.centerPadding + " 0px")  if _.options.centerMode is true
    return

  Slick::setFade = ->
    _ = this
    targetLeft = undefined
    _.$slides.each (index, element) ->
      targetLeft = (_.slideWidth * index) * -1
      $(element).css
        position: "relative"
        left: targetLeft
        top: 0
        zIndex: 800
        opacity: 0

      return

    _.$slides.eq(_.currentSlide).css
      zIndex: 900
      opacity: 1

    return

  Slick::setPosition = ->
    _ = this
    _.setValues()
    _.setDimensions()
    if _.options.fade is false
      _.setCSS _.getLeft(_.currentSlide)
    else
      _.setFade()
    return

  Slick::setProps = ->
    _ = this
    _.positionProp = (if _.options.vertical is true then "top" else "left")
    if _.positionProp is "top"
      _.$slider.addClass "slick-vertical"
    else
      _.$slider.removeClass "slick-vertical"
    _.cssTransitions = true  if _.options.useCSS is true  if document.body.style.WebkitTransition isnt `undefined` or document.body.style.MozTransition isnt `undefined` or document.body.style.msTransition isnt `undefined`
    if document.body.style.MozTransform isnt `undefined`
      _.animType = "MozTransform"
      _.transformType = "-moz-transform"
      _.transitionType = "MozTransition"
    if document.body.style.webkitTransform isnt `undefined`
      _.animType = "webkitTransform"
      _.transformType = "-webkit-transform"
      _.transitionType = "webkitTransition"
    if document.body.style.msTransform isnt `undefined`
      _.animType = "transform"
      _.transformType = "transform"
      _.transitionType = "transition"
    _.transformsEnabled = (_.animType isnt null)
    return

  Slick::setValues = ->
    _ = this
    _.listWidth = _.$list.width()
    _.listHeight = _.$list.height()
    if _.options.vertical is false
      _.slideWidth = Math.ceil(_.listWidth / _.options.slidesToShow)
    else
      _.slideWidth = Math.ceil(_.listWidth)
    return

  Slick::setSlideClasses = (index) ->
    _ = this
    centerOffset = undefined
    allSlides = undefined
    indexOffset = undefined
    _.$slider.find(".slick-slide").removeClass("slick-active").removeClass "slick-center"
    allSlides = _.$slider.find(".slick-slide")
    if _.options.centerMode is true
      centerOffset = Math.floor(_.options.slidesToShow / 2)
      if _.options.infinite is true
        if index >= centerOffset and index <= (_.slideCount - 1) - centerOffset
          _.$slides.slice(index - centerOffset, index + centerOffset + 1).addClass "slick-active"
        else
          indexOffset = _.options.slidesToShow + index
          allSlides.slice(indexOffset - centerOffset + 1, indexOffset + centerOffset + 2).addClass "slick-active"
        if index is 0
          allSlides.eq(allSlides.length - 1 - _.options.slidesToShow).addClass "slick-center"
        else allSlides.eq(_.options.slidesToShow).addClass "slick-center"  if index is _.slideCount - 1
      _.$slides.eq(index).addClass "slick-center"
    else
      if index > 0 and index < (_.slideCount - _.options.slidesToShow)
        _.$slides.slice(index, index + _.options.slidesToShow).addClass "slick-active"
      else if allSlides.length <= _.options.slidesToShow
        allSlides.addClass "slick-active"
      else
        indexOffset = (if _.options.infinite is true then _.options.slidesToShow + index else index)
        allSlides.slice(indexOffset, indexOffset + _.options.slidesToShow).addClass "slick-active"
    _.lazyLoad()  if _.options.lazyLoad is "ondemand"
    return

  Slick::setupInfinite = ->
    _ = this
    i = undefined
    slideIndex = undefined
    infiniteCount = undefined
    _.options.centerMode = false  if _.options.fade is true or _.options.vertical is true
    if _.options.infinite is true and _.options.fade is false
      slideIndex = null
      if _.slideCount > _.options.slidesToShow
        if _.options.centerMode is true
          infiniteCount = _.options.slidesToShow + 1
        else
          infiniteCount = _.options.slidesToShow
        i = _.slideCount
        while i > (_.slideCount - infiniteCount)
          slideIndex = i - 1
          $(_.$slides[slideIndex]).clone().attr("id", "").prependTo(_.$slideTrack).addClass "slick-cloned"
          i -= 1
        i = 0
        while i < infiniteCount
          slideIndex = i
          $(_.$slides[slideIndex]).clone().attr("id", "").appendTo(_.$slideTrack).addClass "slick-cloned"
          i += 1
        _.$slideTrack.find(".slick-cloned").find("[id]").each ->
          $(this).attr "id", ""
          return

    return

  Slick::selectHandler = (event) ->
    _ = this
    asNavFor = (if _.options.asNavFor? then $(_.options.asNavFor).getSlick() else null)
    index = parseInt($(event.target).parent().attr("index"))
    index = 0  unless index
    return  if _.slideCount <= _.options.slidesToShow
    _.slideHandler index
    if asNavFor?
      return  if asNavFor.slideCount <= asNavFor.options.slidesToShow
      asNavFor.slideHandler index
    return

  Slick::slideHandler = (index) ->
    targetSlide = undefined
    animSlide = undefined
    slideLeft = undefined
    unevenOffset = undefined
    targetLeft = null
    _ = this
    return false  if _.animating is true
    targetSlide = index
    targetLeft = _.getLeft(targetSlide)
    slideLeft = _.getLeft(_.currentSlide)
    unevenOffset = (if _.slideCount % _.options.slidesToScroll isnt 0 then _.options.slidesToScroll else 0)
    _.currentLeft = (if _.swipeLeft is null then slideLeft else _.swipeLeft)
    if _.options.infinite is false and _.options.centerMode is false and (index < 0 or index > (_.slideCount - _.options.slidesToShow + unevenOffset))
      if _.options.fade is false
        targetSlide = _.currentSlide
        _.animateSlide slideLeft, ->
          _.postSlide targetSlide
          return

      return false
    else if _.options.infinite is false and _.options.centerMode is true and (index < 0 or index > (_.slideCount - _.options.slidesToScroll))
      if _.options.fade is false
        targetSlide = _.currentSlide
        _.animateSlide slideLeft, ->
          _.postSlide targetSlide
          return

      return false
    clearInterval _.autoPlayTimer  if _.options.autoplay is true
    if targetSlide < 0
      if _.slideCount % _.options.slidesToScroll isnt 0
        animSlide = _.slideCount - (_.slideCount % _.options.slidesToScroll)
      else
        animSlide = _.slideCount - _.options.slidesToScroll
    else if targetSlide > (_.slideCount - 1)
      animSlide = 0
    else
      animSlide = targetSlide
    _.animating = true
    _.options.onBeforeChange.call this, _, _.currentSlide, animSlide  if _.options.onBeforeChange isnt null and index isnt _.currentSlide
    _.currentSlide = animSlide
    _.setSlideClasses _.currentSlide
    _.updateDots()
    _.updateArrows()
    if _.options.fade is true
      _.fadeSlide animSlide, ->
        _.postSlide animSlide
        return

      return false
    _.animateSlide targetLeft, ->
      _.postSlide animSlide
      return

    return

  Slick::startLoad = ->
    _ = this
    if _.options.arrows is true and _.slideCount > _.options.slidesToShow
      _.$prevArrow.hide()
      _.$nextArrow.hide()
    _.$dots.hide()  if _.options.dots is true and _.slideCount > _.options.slidesToShow
    _.$slider.addClass "slick-loading"
    return

  Slick::swipeDirection = ->
    xDist = undefined
    yDist = undefined
    r = undefined
    swipeAngle = undefined
    _ = this
    xDist = _.touchObject.startX - _.touchObject.curX
    yDist = _.touchObject.startY - _.touchObject.curY
    r = Math.atan2(yDist, xDist)
    swipeAngle = Math.round(r * 180 / Math.PI)
    swipeAngle = 360 - Math.abs(swipeAngle)  if swipeAngle < 0
    return "left"  if (swipeAngle <= 45) and (swipeAngle >= 0)
    return "left"  if (swipeAngle <= 360) and (swipeAngle >= 315)
    return "right"  if (swipeAngle >= 135) and (swipeAngle <= 225)
    "vertical"

  Slick::swipeEnd = (event) ->
    _ = this
    asNavFor = (if _.options.asNavFor? then $(_.options.asNavFor).getSlick() else null)
    _.dragging = false
    return false  if _.touchObject.curX is `undefined`
    if _.touchObject.swipeLength >= _.touchObject.minSwipe
      $(event.target).on "click.slick", (event) ->
        event.stopImmediatePropagation()
        event.stopPropagation()
        event.preventDefault()
        $(event.target).off "click.slick"
        return

      switch _.swipeDirection()
        when "left"
          _.slideHandler _.currentSlide + _.options.slidesToScroll
          asNavFor.slideHandler asNavFor.currentSlide + asNavFor.options.slidesToScroll  if asNavFor?
          _.touchObject = {}
        when "right"
          _.slideHandler _.currentSlide - _.options.slidesToScroll
          asNavFor.slideHandler asNavFor.currentSlide - asNavFor.options.slidesToScroll  if asNavFor?
          _.touchObject = {}
    else
      if _.touchObject.startX isnt _.touchObject.curX
        _.slideHandler _.currentSlide
        asNavFor.slideHandler asNavFor.currentSlide  if asNavFor?
        _.touchObject = {}
    return

  Slick::swipeHandler = (event) ->
    _ = this
    if (_.options.swipe is false) or ("ontouchend" of document and _.options.swipe is false)
      return
    else return  if (_.options.draggable is false) or (_.options.draggable is false and not event.originalEvent.touches)
    _.touchObject.fingerCount = (if event.originalEvent and event.originalEvent.touches isnt `undefined` then event.originalEvent.touches.length else 1)
    _.touchObject.minSwipe = _.listWidth / _.options.touchThreshold
    switch event.data.action
      when "start"
        _.swipeStart event
      when "move"
        _.swipeMove event
      when "end"
        _.swipeEnd event

  Slick::swipeMove = (event) ->
    _ = this
    curLeft = undefined
    swipeDirection = undefined
    positionOffset = undefined
    touches = undefined
    touches = (if event.originalEvent isnt `undefined` then event.originalEvent.touches else null)
    curLeft = _.getLeft(_.currentSlide)
    return false  if not _.dragging or touches and touches.length isnt 1
    _.touchObject.curX = (if touches isnt `undefined` then touches[0].pageX else event.clientX)
    _.touchObject.curY = (if touches isnt `undefined` then touches[0].pageY else event.clientY)
    _.touchObject.swipeLength = Math.round(Math.sqrt(Math.pow(_.touchObject.curX - _.touchObject.startX, 2)))
    swipeDirection = _.swipeDirection()
    return  if swipeDirection is "vertical"
    event.preventDefault()  if event.originalEvent isnt `undefined` and _.touchObject.swipeLength > 4
    positionOffset = (if _.touchObject.curX > _.touchObject.startX then 1 else -1)
    if _.options.vertical is false
      _.swipeLeft = curLeft + _.touchObject.swipeLength * positionOffset
    else
      _.swipeLeft = curLeft + (_.touchObject.swipeLength * (_.$list.height() / _.listWidth)) * positionOffset
    return false  if _.options.fade is true or _.options.touchMove is false
    if _.animating is true
      _.swipeLeft = null
      return false
    _.setCSS _.swipeLeft
    return

  Slick::swipeStart = (event) ->
    _ = this
    touches = undefined
    if _.touchObject.fingerCount isnt 1 or _.slideCount <= _.options.slidesToShow
      _.touchObject = {}
      return false
    touches = event.originalEvent.touches[0]  if event.originalEvent isnt `undefined` and event.originalEvent.touches isnt `undefined`
    _.touchObject.startX = _.touchObject.curX = (if touches isnt `undefined` then touches.pageX else event.clientX)
    _.touchObject.startY = _.touchObject.curY = (if touches isnt `undefined` then touches.pageY else event.clientY)
    _.dragging = true
    return

  Slick::unfilterSlides = ->
    _ = this
    if _.$slidesCache isnt null
      _.unload()
      _.$slideTrack.children(@options.slide).remove()
      _.$slidesCache.appendTo _.$slideTrack
      _.reinit()
    return

  Slick::unload = ->
    _ = this
    $(".slick-cloned", _.$slider).remove()
    _.$dots.remove()  if _.$dots
    if _.$prevArrow
      _.$prevArrow.remove()
      _.$nextArrow.remove()
    _.$slides.removeClass("slick-slide slick-active slick-visible").removeAttr "style"
    return

  Slick::updateArrows = ->
    _ = this
    if _.options.arrows is true and _.options.infinite isnt true and _.slideCount > _.options.slidesToShow
      _.$prevArrow.removeClass "slick-disabled"
      _.$nextArrow.removeClass "slick-disabled"
      if _.currentSlide is 0
        _.$prevArrow.addClass "slick-disabled"
        _.$nextArrow.removeClass "slick-disabled"
      else if _.currentSlide >= _.slideCount - _.options.slidesToShow
        _.$nextArrow.addClass "slick-disabled"
        _.$prevArrow.removeClass "slick-disabled"
    return

  Slick::updateDots = ->
    _ = this
    if _.$dots isnt null
      _.$dots.find("li").removeClass "slick-active"
      _.$dots.find("li").eq(Math.floor(_.currentSlide / _.options.slidesToScroll)).addClass "slick-active"
    return

  $.fn.slick = (options) ->
    _ = this
    _.each (index, element) ->
      element.slick = new Slick(element, options)
      return


  $.fn.slickAdd = (slide, slideIndex, addBefore) ->
    _ = this
    _.each (index, element) ->
      element.slick.addSlide slide, slideIndex, addBefore
      return


  $.fn.slickCurrentSlide = ->
    _ = this
    _.get(0).slick.getCurrent()

  $.fn.slickFilter = (filter) ->
    _ = this
    _.each (index, element) ->
      element.slick.filterSlides filter
      return


  $.fn.slickGoTo = (slide) ->
    _ = this
    _.each (index, element) ->
      asNavFor = (if element.slick.options.asNavFor? then $(element.slick.options.asNavFor) else null)
      asNavFor.slickGoTo slide  if asNavFor?
      element.slick.slideHandler slide
      return


  $.fn.slickNext = ->
    _ = this
    _.each (index, element) ->
      element.slick.changeSlide data:
        message: "next"

      return


  $.fn.slickPause = ->
    _ = this
    _.each (index, element) ->
      element.slick.autoPlayClear()
      element.slick.paused = true
      return


  $.fn.slickPlay = ->
    _ = this
    _.each (index, element) ->
      element.slick.paused = false
      element.slick.autoPlay()
      return


  $.fn.slickPrev = ->
    _ = this
    _.each (index, element) ->
      element.slick.changeSlide data:
        message: "previous"

      return


  $.fn.slickRemove = (slideIndex, removeBefore) ->
    _ = this
    _.each (index, element) ->
      element.slick.removeSlide slideIndex, removeBefore
      return


  $.fn.slickGetOption = (option) ->
    _ = this
    _.get(0).slick.options[option]

  $.fn.slickSetOption = (option, value, refresh) ->
    _ = this
    _.each (index, element) ->
      element.slick.options[option] = value
      if refresh is true
        element.slick.unload()
        element.slick.reinit()
      return


  $.fn.slickUnfilter = ->
    _ = this
    _.each (index, element) ->
      element.slick.unfilterSlides()
      return


  $.fn.unslick = ->
    _ = this
    _.each (index, element) ->
      element.slick.destroy()  if element.slick
      return


  $.fn.getSlick = ->
    s = null
    _ = this
    _.each (index, element) ->
      s = element.slick
      return

    s

  return