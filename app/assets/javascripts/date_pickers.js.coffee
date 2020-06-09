ready = ->
  
  $('#posting_date_start_posting_date_start').datepicker({
    changeMonth:true,
    changeYear:true
  });
  $('#posting_date_end_posting_date_end').datepicker({
    changeMonth:true,
    changeYear:true
  });
  
$(document).ready(ready)
$(document).on('page:load', ready)