class TeachersController < ApplicationController
  before_action :set_teacher, only: %i[ show destroy edit update ]
  def index
    @teachers = Teacher.all
  end

  def show
  end

  def new
    @teacher = Teacher.new
    @teacher.user = User.new
    @subject_levels = SubjectLevel.levels_by_subject
  end

  def create
    @user = User.new(user_params)
    @user.balance = 0.0
    @schedule = Schedule.new
    @teacher = Teacher.new(teacher_params)
    @teacher.user = @user
    @teacher.schedule = @schedule
    begin 
      ActiveRecord::Base.transaction do
        @schedule.save!
        @user.save!
        @teacher.save!
        puts(level_params)
        level_params.each do |s, l|
          (@teacher.subject_levels << SubjectLevel.find(l)) if !l.empty?
        end
      end
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
      flash[:error] = @teacher.errors.full_messages.to_sentence + 
                      @user.errors.full_messages.to_sentence
    else
      redirect_to teacher_path(@teacher), notice: "Teacher was successfully created"
    end
  end

  def edit
    @subject_levels = SubjectLevel.levels_by_subject
  end

  def update
    begin 
      ActiveRecord::Base.transaction do
        @teacher.user.update!(user_params)
        @teacher.update!(teacher_params)
        @teacher.subject_levels.clear
        level_params.each do |s, l|
            @teacher.subject_levels << SubjectLevel.find(l) if !l.empty?
        end
      end
    rescue ActiveRecord::RecordInvalid
      @subject_levels = SubjectLevel.subjects.map{|s|SubjectLevel.for_subject(s)}
      render :edit, status: :unprocessable_entity
      flash[:error] = @teacher.errors.full_messages.to_sentence + 
                      @user.errors.full_messages.to_sentence
    else
      redirect_to teacher_path(@teacher), notice: "Teacher was successfully updated"
    end
  end

  def destroy
    @teacher.destroy
    redirect_to teachers_path, notice: "Teacher was successfully destroyed."
  end

  def search
    @teachers = if params[:search].empty? then Teacher.all
      else Teacher.search_by_name(params[:search])
    end
  end

  private
  def set_teacher
    @teacher = Teacher.find(params[:id])
    @user = @teacher.user
  end
  def teacher_params
    params.require(:teacher).permit(:name)
  end
  def user_params
    params.require(:teacher).permit(user: [:email, :is_active])[:user]
  end
  def level_params
    params.require(:teacher).permit(level: SubjectLevel.subjects.map(&:to_sym))[:level]
  end
end
