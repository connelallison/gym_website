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

post '/wellbeing/physios/:id/delete' do
  @physio = Physio.find(params[:id].to_i())
  if (@physio == nil); redirect('/wellbeing/physios'); end
  if (@physio != nil); @physio.delete(); end
  redirect("/wellbeing/physios")
end

get '/wellbeing/physios/:id/edit' do
  @physio = Physio.find(params[:id].to_i())
  erb(:"physios/edit")
end

post '/wellbeing/physios' do
  @physio = Physio.new(params)
  @physio.save()
  redirect("wellbeing/physios")
end

get '/wellbeing/physios/:id' do
  @physio = Physio.find(params[:id].to_i())
  @conditions = @physio.conditions()
  erb(:"physios/show")
end
