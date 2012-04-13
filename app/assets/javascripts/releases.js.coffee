# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class @Release
  @showNotes: (id) ->
    $.ajax "/releases/#{id}/notes",
      type: 'GET'
      dataType: 'html'
      success: (data, status, xhr) ->
        $('#notes').html(data)
        $('#notes').reveal();