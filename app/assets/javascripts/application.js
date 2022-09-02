//= require jquery_ujs 
//= require jquery-ui/widgets/sortable
//= require rails_sortable
import "jquery"
import "@hotwired/turbo-rails"
import "@materializecss/materialize"
$( document ).on('turbo:load', function() {   
    $('.sortable').railsSortable();
    $('.datepicker').datepicker();
    $('.timepicker').timepicker();
    $(".dropdown-trigger").dropdown();
    $('.tabs').tabs();
    $('select').formSelect();
    $('select').addClass("hide-select");
    $('label').addClass("active");
}); 