module OccurrencesHelper
    class CalendarOccurrence
        attr_accessor :start_time, :end_time, :occurable
        def initialize(o, s=nil)
            self.start_time = o.start_time && o.start_time.localtime
            self.end_time = o.end_time && o.end_time.localtime
            self.occurable = s
        end
    end
end
