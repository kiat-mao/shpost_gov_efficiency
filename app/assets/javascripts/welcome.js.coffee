$(document).on "turbolinks:load", ->
  ready()

ready = ->
	if $("#show_modal").val()=="true"
		$('#modal').modal('show');