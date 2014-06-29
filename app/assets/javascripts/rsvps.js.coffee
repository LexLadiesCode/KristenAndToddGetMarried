$ ->
  $('input#rsvp_attending').change ->
    checkbox = $(this)
    guest_count_wrapper = $('#guest-count-wrapper')
    guest_count_field = $('#rsvp_guest_count')
    if checkbox.is(':checked')
      guest_count_field.val('1')
      guest_count_wrapper.fadeIn('fast')
    else
      guest_count_field.val('0')
      guest_count_wrapper.fadeOut('fast')
