# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

getNotificationData = (sender) ->
  div = $(sender).parents('.notification-container')
  return([div, div.data()])

bindHandlers = (container) ->
  relative_root_url = $('body').data('root')

  swapContent = (container, content, remove=true) -> 
    newContainer = $(content).hide()
    container.after(newContainer)
    container.animate height: 0, opacity: 0, -> container.remove() if remove
    newContainer.animate height: 'toggle', opacity: 1
    bindHandlers(newContainer)
  
  $('form.edit_notification', container).submit ->
    sender = $(this)
    [container, data] = getNotificationData(sender)
    $.ajax "#{relative_root_url}/notifications/#{data.notificationId}",
      type: 'PUT'
      data: sender.serialize()
      complete: (data, status, xhr) -> swapContent(container, data.responseText)
    return false
    
  $('form.new_notification', container).submit ->
    sender = $(this)
    [container, data] = getNotificationData(sender)
    projectId = $('#new_notification_form').data('projectId')
    $('#new_notification_form form input[name="notification[project_id]"]').val(projectId)
    $.ajax "#{relative_root_url}/notifications",
      type: 'POST'
      data: sender.serialize()
      complete: (data, status, xhr) -> 
        if data.getResponseHeader('X-Valid-Model') == 'true'
          bindHandlers(newContainer = $(data.responseText).hide())
          $('#notifications_table').append(newContainer)
          newContainer.slideDown()
          $('#new_notification_button').slideDown();
          $('#new_notification_form').slideUp();
        else
          container.replaceWith(data.responseText)
    return false
  
  $('.edit_notification .cancel.button', container).click ->
    $('input[name="cancel"]',$(this).closest('form')).val(true)
    return true

  $('.new_notification .cancel.button', container).click ->
    $('#new_notification_form').slideUp()
    $('#new_notification_button').slideDown();
    return false
    
  $('a.edit.notification-link', container).click ->
    sender = $(this)
    [container, data] = getNotificationData(sender)
    $.ajax "#{relative_root_url}/notifications/#{data.notificationId}/edit",
      success: (data, status, xhr) -> swapContent(container, data)
    return false
  
  $('a.delete.notification-link', container).click ->
    sender = $(this)
    [container, data] = getNotificationData(sender)
    $.ajax "#{relative_root_url}/notifications/#{data.notificationId}.json",
      type: 'DELETE'
      success: (data, status, xhr) -> 
        container.animate height: 0, opacity: 0, -> container.remove()
      
  $('a.create.notification-link', container).click ->
    form = $('#new_notification_form')
    projectId = form.data('projectId')
    $.ajax "#{relative_root_url}/projects/#{projectId}/notifications/new",
      complete: (data, status, xhr) -> 
        form.html(data.responseText)
        bindHandlers(form)
        $('#new_notification_button').slideUp();
        form.slideDown();
    return false
    
$ ->
  $('.tabbish.sub-nav dd a').click ->
    $('.tabs-content li.active').removeClass('active')
    $('.tabbish.sub-nav dd.active').removeClass('active')
    $(this.hash).addClass('active')
    $(this).parent().addClass('active')
    true
    
  for container of $('.notification-container')
    bindHandlers(container)
  
  d = $('#project_description')
  d.height($('#text_fields').height()-27)
  d.width(d.parent().width())