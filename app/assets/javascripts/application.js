//= require jquery
//= require jquery_ujs 
//= require materialize
//= require jquery-ui/widgets/sortable
//= require rails_sortable
// import "@hotwired/turbo-rails"
// import "controllers"
$(document).ready(function(){
    $('.sortable').railsSortable();
    $('.datepicker').datepicker();
    $('.timepicker').timepicker();
    $(".dropdown-trigger").dropdown();
    $('select').formSelect();
    $('select').addClass("hide-select");
    $('label').addClass("active");
});