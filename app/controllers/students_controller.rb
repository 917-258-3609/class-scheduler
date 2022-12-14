class StudentsController < ApplicationController
  include OccurrencesHelper
  before_action :set_student, only: %i[ show destroy edit update ]
  def index
    @students = Student.all
  end

  def show
    start_date = params.fetch(:start_date, Date.today).to_date
    btime = start_date.beginning_of_week.beginning_of_day
    etime = start_date.end_of_week.end_of_day
    
    @calendar_occurrences = \
      @student.courses.includes(:schedule).active.map{|c| 
        c.schedule.occurrences_between(btime, etime).map{|o|
          CalendarOccurrence.new(o, c)
        }
      }.flatten
  end

  def new
    @student = Student.new
    @student.user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.balance = 0.0
    @schedule = Schedule.new
    @student = Student.new(student_params)
    @student.user = @user
    @student.schedule = @schedule
    begin 
      ActiveRecord::Base.transaction do
        @schedule.save!
        @user.save!
        @student.save!
      end
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
      flash[:error] = @student.errors.full_messages.to_sentence + 
                      @user.errors.full_messages.to_sentence
    else
      redirect_to student_path(@student), notice: "Student was successfully created"
    end
  end

  def edit
  end

  def update
    begin 
      ActiveRecord::Base.transaction do
        @user.update!(user_params)
        @student.update!(student_params)
      end
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
      flash[:error] = @student.errors.full_messages.to_sentence + 
                      @user.errors.full_messages.to_sentence
    else
      redirect_to student_path(@student), notice: "Student was successfully updated"
    end
  end

  def destroy
    @student.destroy
    redirect_to students_path, notice: "Student was successfully destroyed."
  end

  def search
    @students = if params[:search].blank? then Student.all
      else Student.search_by_full_name(params[:search])
    end
  end

  private
  def set_student
    @student = Student.find(params[:id])
  end
  def student_params
    params.require(:student).permit(:first_name, :last_name)
  end
  def user_params
    params.require(:student).permit(user: [:email, :is_active])[:user]
  end
end
