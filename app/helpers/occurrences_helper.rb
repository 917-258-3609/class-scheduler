module OccurrencesHelper
    class CalendarOccurrence
        attr_accessor :start_time, :end_time, :schedule
        def initialize(o, s=nil)
            self.start_time = o.start_time
            self.end_time = o.end_time 
            self.schedule = s
        end
    end
end
