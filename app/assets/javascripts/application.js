//= require jquery
//= require jquery_ujs 
//= require materialize
// import "@hotwired/turbo-rails"
// import "controllers"
$(document).ready(function(){
    $('.datepicker').datepicker();
    $('.timepicker').timepicker();
    $(".dropdown-trigger").dropdown();
    $('select').formSelect();
    $('select').addClass("hide-select");
    $('label').addClass("active");
});