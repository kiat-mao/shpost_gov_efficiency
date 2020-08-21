$(document).on "turbolinks:load", ->
  ready()

ready = ->
	if $("#show_modal").val()=="true"
		$('#modal').modal('show');
		set_is_read()


set_is_read = -> 
	      $.ajax({
          type : 'POST',
          url : '/user_messages/set_is_read/',
          data: "message_id=" + $('#message_id').val(),
          dataType : 'script'
          });