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
//= require underscore
//= require d3
//= require angular
//= require socket.io
//= require bootstrap-sprockets
//= require_self
//= require_tree ./markets

var market = angular.module("market", []);

var socket = io.connect("localhost:3001");
socket.on('message', function(msg){
  console.log(msg);
});

