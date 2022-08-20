class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show destroy edit update ]
  def index
    @students = Student.all
  end

  def show
  end

  def new
    @student = Student.new
    @student.user = User.new
  end

  def create
    puts(student_params)
    puts(user_params)
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
    @students = if params[:search].nil? then Student.all
      else Student.where("first_name = ? OR last_name = ?", params[:search], params[:search])
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
