load_gifts_list = ->
  container = $('#gifts-list-wrapper')
  return if container.length < 1
  url = container.data('url')
  $.get url, (response) ->
    container.empty()
    container.append(response)

$ ->
  load_gifts_list()
