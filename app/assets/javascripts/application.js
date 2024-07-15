// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap-datepicker
//= require wice_grid
//= require select2
//= require select2_locale_zh-CN

//= require bootstrap-table/bootstrap-table

//= require turbolinks
//= require_tree .

// var ready;

//显示遮罩层
function showMask(){     
  document.getElementById('mid').style.display="block";  //打开遮罩层；
  // $('#mid').show(0,setTimeout(function(){
    // hideMask();
  // },50000));
}

//隐藏遮罩层  
function hideMask(){
  document.getElementById('mid').style.display="none";    //关闭遮罩层；
}

var ready;
ready = function() {
	$("a.showmask").click(function(event) {
    showMask();
  });

	$("input.showmask").click(function(event) {
		showMask();
	});

	$("button.wg-external-submit-button").click(function(event) {
		showMask();
	});

	$("button.wg-external-reset-button").click(function(event) {
		showMask();
	});
}

$(document).on('turbolinks:load', ready);