jQuery ->
  # Submit the photo form automatically.
  $('#profile_photo_field').on 'change', () ->
    $('#upload_profile_photo').submit()
    
  # Photo form: Hide field, show 'loading'.
  $('#upload_profile_photo').on 'submit', () ->
    $('#profile_photo_before').hide()
    $('#profile_photo_after').show()
    
  # Validation: Alert if photo is absent.
  $('#user_form').on 'submit', (e) ->
    if !$("#profile_photo_id").val()?.length
      alert("Add your face! (Use the photo upload field at the top of the form.)")
      e.preventDefault()    
  
  # Attend Event Buttons
  $(document).on 'click', '.attend_event', (e) ->
    $(this).hide().parent().append('<i class="icon-spinner icon-spin"></i>')
      
  # If this page contains a faces gallery...
  if $('#user_gallery').length > 0
    
    # Show face's name in Quiz Mode.
    $(document).on 'click', '.quiz .quiz_link', (e) ->
      $(this).parent().find('.user_name').css("visibility", "visible")
      $(this).parents('li').first().addClass("face_shown")
      e.preventDefault()
      
    $(document).on 'click', '#quiz_header', (e) ->
      if $(this).hasClass("inactive")
        $(this).removeClass("inactive").find("span").text('OK: Names are hidden! Click faces to reveal.')
        window.activate_quiz(true)
      else
        $(this).addClass("inactive").find("span").text('Activate Quiz Mode.')
        window.activate_quiz(false)

    window.activate_quiz = (active) ->
      window.quiz = active
      if active
        $('#user_gallery_list').addClass("quiz")
      else
        $('#user_gallery_list').removeClass("quiz")
    
    # Replace pagination with dynamic loader.
    $(document).on 'click', '#append_more_results', (e) ->
      url = $('.pagination .next_page').attr('href')
  
      $('#append_more_results').hide()
      $('#paginate_loading').show()
  
      if url
        # Load the next page's contents. This hits 'users/index.js.coffee',
        # so go there to see how the story continues!
        $.getScript(url)
      e.preventDefault()
    
    # Add button to Show More Faces.
    window.setup_pagination = () ->
      # If there are pages...
      if $('.pagination').length > 0      
        # Add a link to load more faces.
        $('#append_and_paginate').prepend('<h2 class="title-bg" id="append_more_results"><a href="#">Show More Faces</a></h2>').prepend('<img src="/assets/loading.gif" alt="Loading..." id="paginate_loading" />');
    
        # Hide the pagination links.
        $('.pagination').hide()
        
    # Category Filters: Load faces via XHR.
    $(document).on 'click', '#filterOptions a', (e) ->
      filter_li = $(this).parent()
      filter_li.append(' <i class="icon-spinner icon-spin filter_loading"></i>')
      url = $(this).attr('href')
      
      # "Activate" the current filter.
      $('#filterOptions li').removeClass('active')
      filter_li.addClass('active')
      
      $.getScript(url)
      e.preventDefault()
      
    # Setup Pagination onLoad.
    window.setup_pagination()