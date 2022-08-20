require "./test/sets/courses"
require "./test/sets/occurrences"
require "./test/sets/schedules"
require "./test/sets/students"
require "./test/sets/subject_levels"
require "./test/sets/subjects"
require "./test/sets/teachers"
require "./test/sets/users"
module ConstructionHelper
   include ConstructionHelper::Courses
   include ConstructionHelper::Occurrences
   include ConstructionHelper::Schedules
   include ConstructionHelper::Students
   include ConstructionHelper::SubjectLevels
   include ConstructionHelper::Subjects
   include ConstructionHelper::Teachers
   include ConstructionHelper::Users
end