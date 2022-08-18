class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]
  before_action :sanitize_params, only: %i[ create update ]
  def show
    @occurrences = @course.schedule.occurrences_between(Time.now, Time.now+1.month)
  end

  def index
    @courses_info = Course.active.includes(:schedule).map do |x|
      {course: x, next_occurrence: x.schedule.next_occurring_time}
    end.compact
  end

  def new
    @course = Course.new
  end

  def create
    @recurrence = Occurrence.new(occurrence_params)
    @schedule = Schedule.new
    @schedule.occurrences << @recurrence
    @course = Course.new(course_params)
    @course.schedule = @schedule
    begin 
      ActiveRecord::Base.transaction do
        @recurrence.save!
        @schedule.save!
        @course.save!
      end
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
      flash[:error] = @schedule.errors.full_messages.to_sentence + "\n" + 
                      @course.errors.full_messages.to_sentence + "\n" +
                      @recurrence.errors.full_messages.to_sentence
    else
      redirect_to course_path(@course), notice: "Course was successfully created"
    end
  end

  def edit
    redirect_to edit_schedule_path(@course.schedule)
  end

  def update
  end

  def destroy
    @course.make_not_active
    redirect_to courses_path, notice: "Course was successfully deactivated."
  end
  private
  def sanitize_params
    params[:course][:occurrence][:start_time] = Time.parse(params[:course][:occurrence][:start_time]).utc
    params[:course][:occurrence][:duration] = ActiveSupport::Duration.build(
      ChronicDuration.parse(params[:course][:occurrence][:duration]+":00")
    )
    params[:course][:occurrence][:period] = ActiveSupport::Duration.build(
      params[:course][:occurrence][:period].to_i
    )
  end
  def set_course
    @course = Course.find(params[:id])
  end
  def course_params
    params.require(:course).permit(:subject_level_id, :teacher_id, student_ids: [])
  end
  def occurrence_params
    params.require(:course).permit(occurrence: [:period, :start_time, :duration, :count, days: []])[:occurrence]
  end
end