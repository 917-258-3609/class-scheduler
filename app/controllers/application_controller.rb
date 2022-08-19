class ApplicationController < ActionController::Base
    before_action :set_subjects
    private
    def set_subjects
        @subjects = Subject.all
    end
end
