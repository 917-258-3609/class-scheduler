class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]
  before_action :sanitize_params, only: %i[ create update ]
  def show
    start_date = params.fetch(:start_date, Date.today).to_date
    btime = start_date.beginning_of_month.beginning_of_week.beginning_of_day
    etime = start_date.end_of_month.end_of_week.end_of_day
    @occurrences = @course.schedule.occurrences_between(btime, etime)
  end

  def index
    @courses_info = Course.active.includes(:schedule).map do |x|
      {course: x, next_occurrence: x.schedule.next_occurring_time}
    end.compact
  end

  def new
    redirect_to new_subject_level_path, notice: "Create a subject first!" if SubjectLevel.all.empty?
    redirect_to new_teacher_path, notice: "Create a teacher first!" if Teacher.all.empty?
    redirect_to new_student_path, notice: "Create a student first!" if Student.all.empty?
    @course = Course.new
  end

  def create
    @recurrence = Occurrence.new(occurrence_params)
    @schedule = Schedule.new
    @schedule.occurrences << @recurrence
    if params[:course][:teacher_id].blank?
      params[:course][:teacher_id] = Teacher.generate_teacher_id(
        @schedule,
        SubjectLevel.find(params[:course][:subject_level_id])
      )
    end
    @course = Course.new(course_params)
    @course.is_active = true
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
      params[:course][:occurrence][:hours].to_i*3600+params[:course][:occurrence][:minutes].to_i*60
    )
    params[:course][:occurrence][:period] = ActiveSupport::Duration.build(
      params[:course][:occurrence][:period].to_i
    )
    params[:course][:fee] = (params[:course][:fee].to_f * 100).to_i
  end
  def set_course
    @course = Course.find(params[:id])
  end
  def course_params
    params.require(:course).permit(:subject_level_id, :teacher_id, :fee, student_ids: [])
  end
  def occurrence_params
    params.require(:course).permit(occurrence: [:period, :start_time, :duration, :count, days: []])[:occurrence]
  end
end
