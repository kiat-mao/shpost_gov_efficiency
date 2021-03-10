$(document).on "turbolinks:load", ->
  ready()

ready = ->
  $('#posting_date_start').datepicker({
    autoclose: true,
    language: "zh-CN"});
  $('#posting_date_end').datepicker({
    autoclose: true,
    language: "zh-CN"});
  $('#message_start_time').datepicker({
    autoclose: true,
    language: "zh-CN"});
  $('#message_end_time').datepicker({
    autoclose: true,
    language: "zh-CN"});
  $('#delivered_date_start').datepicker({
    autoclose: true,
    language: "zh-CN"});
  $('#delivered_date_end').datepicker({
    autoclose: true,
    language: "zh-CN"});

