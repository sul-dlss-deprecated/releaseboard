# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.tabbish.sub-nav dd a').click ->
    $('.tabs-content li.active').removeClass('active')
    $('.tabbish.sub-nav dd.active').removeClass('active')
    $(this.hash).addClass('active')
    $(this).parent().addClass('active')
    true