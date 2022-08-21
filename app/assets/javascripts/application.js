//= require jquery_ujs 
//= require jquery-ui/widgets/sortable
//= require rails_sortable
import "jquery"
import "@materializecss/materialize"
import "@hotwired/turbo-rails"
$(function(){
    $('.sortable').railsSortable();
    $('.datepicker').datepicker();
    $('.timepicker').timepicker();
    $(".dropdown-trigger").dropdown();
    $('select').formSelect();
    $('select').addClass("hide-select");
    $('label').addClass("active");
}); 