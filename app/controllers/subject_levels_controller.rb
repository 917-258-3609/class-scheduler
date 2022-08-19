class SubjectLevelsController < ApplicationController
  before_action :set_level, only: %i[ destroy ]
  # GET /levels/math
  def index
    @subject_levels = SubjectLevel.levels_by_subject
    puts(@subject_levels)
  end

  def new 
    @level = SubjectLevel.new
  end

  def create 
    @level = SubjectLevel.new(level_params)
    subject_name = params[:subject_level][:subject]
    @subject = Subject.find_by(name: subject_name) || Subject.new(name: subject_name)
    @level.subject = @subject

    if (sl = SubjectLevel.for_subject(@subject).by_level.last)
      @level.level = sl.level+1
    else
      @level.level = 0
    end

    begin 
      ActiveRecord::Base.transaction do
        @subject.save! if !Subject.exists?(@subject.id)
        @level.save!
      end
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
      flash[:error] = @level.errors.full_messages.to_sentence + 
                      @subject.errors.full_messages.to_sentence
    else
      redirect_to subject_path(@subject), notice: "Subject level was successfully created"
    end
    
  end
  
  def destroy
    @subject = @level.subject
    if @level.destroy
      redirect_to subject_path(@subject), notice: "Subject level was successfully destroyed"
    else
      render :new, status: :unprocessable_entity
    end
  end
  private
  def set_level
    @level = SubjectLevel.find(params[:id])
  end
  def level_params
    params.require(:subject_level).permit(:level_name)
  end
end
