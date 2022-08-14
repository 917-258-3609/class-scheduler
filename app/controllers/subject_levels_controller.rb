class SubjectLevelsController < ApplicationController
  before_action :set_level, only: %i[ destroy ]
  # GET /levels/math
  def index
    @subject_levels = SubjectLevel.subjects.map{|s|SubjectLevel.for_subject(s).all}
  end

  def new 
    @level = SubjectLevel.new
  end

  def create 
    @level = SubjectLevel.new(level_params)
    subject = level_params[:subject]

    if (sl = SubjectLevel.for_subject(subject).by_rank.last)
      @level.level = sl.level+1
    else
      @level.level = 0
    end
    if @level.save
      redirect_to subject_levels_path, notice: "Subject level was successfully created"
    else
      render :new, status: :unprocessable_entity
    end
    
  end
  
  def destroy
    if @level.destroy
      redirect_to subject_levels_path, notice: "Subject level was successfully destroyed"
    else
      render :new, status: :unprocessable_entity
    end
  end
  private
  def set_level
    @level = SubjectLevel.find(params[:id])
  end
  def level_params
    params.require(:subject_level).permit(:subject, :level_name)
  end
end
