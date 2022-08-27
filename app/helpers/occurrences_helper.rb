module OccurrencesHelper
    class CalendarOccurrence
        attr_accessor :start_time, :end_time, :occurable
        def initialize(o, s=nil)
            self.start_time = o.start_time
            self.end_time = o.end_time 
            self.occurable = s
        end
    end
end
