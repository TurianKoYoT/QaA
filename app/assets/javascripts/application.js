//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require action_cable
//= require jquery.remotipart
//= require cocoon
//= require_tree .

var App = App || {};
App.cable = ActionCable.createConsumer();
