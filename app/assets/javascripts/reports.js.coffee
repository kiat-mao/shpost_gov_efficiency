$(document).on "turbolinks:load", ->
	ready()

ready = ->
	if $("#is_search").val()=="yes"
		$("#export").show();
	else
		$("#export").hide();


	$("input:radio[name='search_time']").click (e) -> 
			if $("input:radio[name='search_time']:checked").val() == 'by_m'
				$("#by_month").show();
				$("#by_date").hide();
			if $("input:radio[name='search_time']:checked").val() == 'by_d'
				$("#by_date").show();
				$("#by_month").hide();

		#alert($("#search_type").val());
		#alert($("input:radio[name='search_time']:checked").val());

		if $("#search_type").val() == 'by_m'
				$("#by_month").show();
		$("#by_date").hide();

	if $("#search_type").val() == 'by_d'
		$("#by_date").show();
		$("#by_month").hide();


	$( "#industry" ).select2({
		width: "300px"
		theme: "bootstrap";
		closeOnSelect: false;
	});

	$( "#product" ).select2({
		width: "180px"
		theme: "bootstrap";
		closeOnSelect: false;
	});

	$( "#btype" ).select2({
		width: "300px"
		theme: "bootstrap";
		closeOnSelect: false;
	});

	