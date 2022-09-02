require "chronic_duration"
require "./app/helpers/occurrences_helper"
class SchedulesController < ApplicationController
  include OccurrencesHelper
  before_action :set_schedule, only: %i[ show edit update destroy move extend ]

  # GET /schedules or /schedules.json
  def index
    @schedules = Schedule.for_course.all
    start_date = params.fetch(:start_date, Date.today).to_date

    btime = start_date.beginning_of_month.beginning_of_week.beginning_of_day
    etime = start_date.end_of_month.end_of_week.end_of_day

    @calendar_occurrences = \
      Course.active.includes(:schedule, :subject_level).map{|c| 
        c.schedule.occurrences_between(btime, etime).map{|o|
          CalendarOccurrence.new(o, c)
        }
      }.flatten
  end

  # GET /schedules/1 or /schedules/1.json
  def show
    @next_occurring_time = @schedule.next_occurring_time
  end

  # GET /schedules/1/edit
  def edit
  end

  # PATCH/PUT /schedules/1 or /schedules/1.json
  def update
    respond_to do |format|
      p = moving_params
      ftime = Time.parse(p[:ftime]).utc
      ttime = Time.parse(p[:ttime]).utc
      if @schedule.move_one(ftime, ttime)
        format.html { redirect_to schedule_url(@schedule), notice: "Schedule was successfully updated." }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end
  def move
      ftime = Time.parse(params[:schedule_move][:ftime]).utc
      ttime = Time.parse(params[:schedule_move][:ttime]).utc
      if @schedule.move_one(ftime, ttime)
        redirect_to schedule_url(@schedule), notice: "Occurrence was successfully moved."
      else  
        render :new, status: :unprocessable_entity
        flash[:error] = @schedule.errors.full_messages.to_sentence 
      end
  end
  def extend
      cnt = params[:schedule_extend][:count].to_i
      if @schedule.extend_many(cnt)
        redirect_to schedule_url(@schedule), notice: "Course was successfully extended by #{cnt} occurrences."
      else  
        render :new, status: :unprocessable_entity
        flash[:error] = @schedule.errors.full_messages.to_sentence 
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end
    # Only allow a list of trusted parameters through.
    def occurrence_params
      params.require(:occurrence).permit(:start_time, :count, :duration, :period)
    end
    def schedule_params
      params.fetch(:schedule, {})
    end
    def moving_params
      params.require(:schedule).permit(:ftime, :ttime)
    end
end
