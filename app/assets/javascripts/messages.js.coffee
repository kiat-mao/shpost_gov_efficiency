$(document).on "turbolinks:load", ->
  ready()

ready = ->
	$("#roles_checked").click (e) -> 
    if($(this).is(':checked'))
      $("#roles input[type=checkbox]").prop("checked",true);
    else
      $("#roles input[type=checkbox]").prop("checked",false);
    
	  