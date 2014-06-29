$ ->
  $(".single-item").slick
    dots: true
    infinite: true
    speed: 300
    slidesToShow: 1
    slidesToScroll: 1

  $(".multiple-items").slick
    dots: true
    infinite: true
    speed: 300
    slidesToShow: 3
    slidesToScroll: 3

  $(".one-time").slick
    dots: true
    infinite: false
    placeholders: false
    speed: 300
    slidesToShow: 5
    touchMove: false
    slidesToScroll: 1

  $(".uneven").slick
    dots: true
    infinite: true
    speed: 300
    slidesToShow: 4
    slidesToScroll: 4

  $(".responsive").slick
    dots: true
    infinite: false
    speed: 300
    slidesToShow: 4
    slidesToScroll: 4
    responsive: [
      {
        breakpoint: 1024
        settings:
          slidesToShow: 3
          slidesToScroll: 3
          infinite: true
          dots: true
      }
      {
        breakpoint: 600
        settings:
          slidesToShow: 2
          slidesToScroll: 2
      }
      {
        breakpoint: 480
        settings:
          slidesToShow: 1
          slidesToScroll: 1
      }
    ]

  $(".center").slick
    centerMode: true
    infinite: true
    centerPadding: "60px"
    slidesToShow: 3
    responsive: [
      {
        breakpoint: 768
        settings:
          arrows: false
          centerMode: true
          centerPadding: "40px"
          slidesToShow: 3
      }
      {
        breakpoint: 480
        settings:
          arrows: false
          centerMode: true
          centerPadding: "40px"
          slidesToShow: 1
      }
    ]

  $(".lazy").slick
    lazyLoad: "ondemand"
    slidesToShow: 3
    slidesToScroll: 1

  $(".autoplay").slick
    dots: true
    infinite: true
    speed: 300
    slidesToShow: 3
    slidesToScroll: 1
    autoplay: true
    autoplaySpeed: 2000

  $(".fade").slick
    dots: true
    infinite: true
    speed: 500
    fade: true
    slide: "div"
    cssEase: "linear"

  $(".add-remove").slick
    dots: true
    slidesToShow: 3
    slidesToScroll: 3

  slideIndex = 1
  $(".js-add-slide").on "click", ->
    slideIndex++
    $(".add-remove").slickAdd "<div><h3>" + slideIndex + "</h3></div>"
    return

  $(".js-remove-slide").on "click", ->
    $(".add-remove").slickRemove slideIndex - 1
    slideIndex--  if slideIndex isnt 0
    return

  $(".filtering").slick
    dots: true
    slidesToShow: 4
    slidesToScroll: 4

  filtered = false
  $(".js-filter").on "click", ->
    if filtered is false
      $(".filtering").slickFilter ":even"
      $(this).text "Unfilter Slides"
      filtered = true
    else
      $(".filtering").slickUnfilter()
      $(this).text "Filter Slides"
      filtered = false
    return

  $(".slider-for").slick
    slidesToShow: 1
    slidesToScroll: 1
    arrows: false
    fade: true
    asNavFor: ".slider-nav"

  $(".slider-nav").slick
    slidesToShow: 3
    slidesToScroll: 1
    asNavFor: ".slider-for"
    dots: true
    centerMode: true
    focusOnSelect: true

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

