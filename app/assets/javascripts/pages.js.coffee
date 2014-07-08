$ ->
  $(window).on "scroll", ->
    if $(window).scrollTop() > 166
      $(".fixed-header").show()
    else
      $(".fixed-header").hide()

  $("ul.nav#sign-nav a").on "click", (event) ->
    event.preventDefault()
    targetID = $(this).attr("href")
    targetST = $(targetID).offset().top - 48
    $("body, html").animate
      scrollTop: targetST + "px"
    , 300

  $(".single-item").slick
    dots: true
    infinite: true
    speed: 300
    slidesToShow: 1
    slidesToScroll: 1

  addBlink = ->
    $(".foreground .firefly").addClass("blink")

  removeBlink = ->
    $(".foreground .firefly").removeClass("blink")

  setInterval ->
     addBlink()
    , 4000

  setInterval ->
     removeBlink()
    , 3553
