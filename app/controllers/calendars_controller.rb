require "chronic_duration"
class CalendarsController < ApplicationController
    before_action :set_date, only: %i[ show ]
    def index
    end
    def show
        @courses = Course.active.includes(:schedule).all.filter{|x|!x.schedule.occurrences_between(@date, @date+1.day).empty?}
    end
    private
    def set_date 
        @date = Time.parse(params[:id]).utc
    end

end