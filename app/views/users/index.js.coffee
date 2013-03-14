if "<%= @gallery_type %>" == "page"
  # @users has been updated by the request to users#index, so add the contents
  # of a new partial to the gallery.
  $('#user_gallery_list').append('<%= j render :partial => "user_gallery" %>')

  # Hide the 'loading', show the button again.
  $('#append_more_results').show()
  $('#paginate_loading').hide()

  if "<%= !@users.next_page.nil? %>" == "true"
    # Replace the navigation, because we get the next page to load by checking
    # the current page.
    $('.pagination').replaceWith('<%= j will_paginate(@users) %>')

    # But then hide it again, because we don't actually need to see it.
    $('.pagination').hide()
  else
    # If there aren't any more pages, remove all pagination-related elements.
    $('#append_and_paginate').remove()

else if "<%= @gallery_type %>" in ["category", "home", "event"]
  $('#user_gallery_container').empty().html('<%= j render :partial => "user_gallery_container" %>')
  $('.filter_loading').remove()
  
  window.setup_pagination()
  
  if window.quiz
    window.activate_quiz(true)