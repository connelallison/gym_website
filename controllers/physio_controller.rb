require_relative ("../models/patient.rb")
require_relative ("../models/physio.rb")
require_relative ("../models/condition.rb")
require_relative ("../models/member.rb")
require_relative ("../models/lesson.rb")
require_relative ("../models/member_lesson.rb")

get '/wellbeing/physios' do
  @physios = Physio.all_ascending_id()
  @show_physios = "show_physios"
  erb(:"physios/index")
end

get '/wellbeing/physios/new' do
  erb(:"physios/new")
end
