// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"
import "@materializecss/materialize"
console.log("HIIIII")
$(function(){
    $('.sortable').railsSortable();
    $('.datepicker').datepicker();
    $('.timepicker').timepicker();
    $(".dropdown-trigger").dropdown();
    $('select').formSelect();
    $('select').addClass("hide-select");
    $('label').addClass("active");
});