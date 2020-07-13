$(document).on "turbolinks:load", ->
  ready()

ready = ->
	if $("#is_search").val()=="yes"
		$("#export").show();
	else
		$("#export").hide();
	