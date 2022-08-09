require "chronic_duration"
class SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[ show edit update destroy ]

  # GET /schedules or /schedules.json
  def index
    @schedules = Schedule.all
    start_date = params.fetch(:start_date, Date.today).to_date

    btime = start_date.beginning_of_month.beginning_of_week.beginning_of_day
    etime = start_date.end_of_month.end_of_week.end_of_day

    @calendar_occurrences = Schedule.all.map{|s| s.calendar_occurrences_in(btime, etime)}.flatten
  end

  # GET /schedules/1 or /schedules/1.json
  def show
    @next_occurring_time = @schedule.next_occurring_time.localtime
    puts(@next_occurring_time)
  end

  # GET /schedules/new
  def new
    @schedule = Schedule.new
  end

  # GET /schedules/1/edit
  def edit
  end

  # POST /schedules or /schedules.json
  def create
    o_params = occurrence_params
    @schedule = Schedule.new()
    @occurrence = Occurrence.new(
      start_time: DateTime.parse(o_params["start_time"]), 
      duration: ActiveSupport::Duration.build(ChronicDuration.parse(o_params["duration"])),
      count: o_params["count"].to_i,
      period: ActiveSupport::Duration.build(o_params["period"].to_i),
    )
    respond_to do |format|
      if @schedule.valid? && @occurrence.valid?
        @schedule.occurrences << @occurrence
        @schedule.save(validate: false)
        @occurrence.save(validate: false)
        format.html { redirect_to schedule_url(@schedule), notice: "Schedule was successfully created." }
        format.json { render :show, status: :created, location: @schedule }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schedules/1 or /schedules/1.json
  def update
    respond_to do |format|
      p = moving_params
      ftime = Time.parse(p[:ftime])
      ttime = Time.parse(p[:ttime])
      puts(ftime)
      puts(ttime)
      if @schedule.move_one(ftime, ttime)
        format.html { redirect_to schedule_url(@schedule), notice: "Schedule was successfully updated." }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1 or /schedules/1.json
  def destroy
    @schedule.destroy

    respond_to do |format|
      format.html { redirect_to schedules_url, notice: "Schedule was successfully destroyed." }
      format.json { head :no_content }
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
