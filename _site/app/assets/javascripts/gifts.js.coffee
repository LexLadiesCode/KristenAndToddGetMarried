thermometerize = (thermometer) ->
  progress = $('.progress', thermometer)
  amount = progress.find('.amount')
  amount.hide()
  progress_pct = parseFloat(progress.data('percent'))
  # Random percentage for testing:
  # progress_pct = Math.floor(Math.random() * (100 + 1))
  goal = $('.goal', thermometer)
  progress_amt = progress.find('.amount')
  progress.animate {width: progress_pct + '%'}, 1200, ->
    amount.text(progress_pct + '%')
    amount.fadeIn(1200)

load_gifts_list = ->
  container = $('#gifts-list-wrapper')
  return if container.length < 1
  url = container.data('url')
  $.get url, (response) ->
    container.empty()
    container.append(response)
    $('.thermometer').each ->
      thermometerize $(this)

$ ->
  load_gifts_list()
