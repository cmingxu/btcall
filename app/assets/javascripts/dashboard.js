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
//= require config
//= require jquery
//= require underscore
//= require d3
//= require dimple
//= require angular
//= require socket.io
//= require angular-socket-io
//= require bootstrap-sprockets
//= require moment
//= require jquery_ujs
//= require bootstrap-datepicker
//= require bootstrap-datepicker.zh-CN
//= require_self
//= require_tree ./dashboard
//= require zeroclipboard

var dashboard = angular.module("dashboard", ["btford.socket-io"]);



function show_error(content) {
  $("#notice_bar .alert").text(content);
  $("#notice_bar").removeClass("hidden");
}

$(document).ready(function () {
  $('.datepicker').datepicker({
    format: 'yyyy-mm-dd',
    language: 'zh-CN'
  }
  );
});

if (!console) console = {log: function() {}};

