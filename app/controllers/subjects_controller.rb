class SubjectsController < ApplicationController
  before_action :set_subject, only: [ :show ]
  def show
    @levels = @subject.subject_levels.by_level
  end

  def destroy
  end

  private
  def set_subject
    @subject = Subject.find(params[:id])
  end
end