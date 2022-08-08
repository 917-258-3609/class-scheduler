module OccurrencesHelper
    class CalendarOccurrence
        attr_accessor :start_time, :end_time, :occurrence
        def initialize(stime, etime, o=nil)
            self.start_time = stime
            self.end_time = end_time
            self.occurrence = o
        end
    end
end
