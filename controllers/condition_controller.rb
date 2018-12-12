require_relative ("../models/patient.rb")
require_relative ("../models/physio.rb")
require_relative ("../models/condition.rb")
require_relative ("../models/member.rb")
require_relative ("../models/lesson.rb")
require_relative ("../models/member_lesson.rb")

post '/wellbeing/conditions/:id/add' do
  @condition = Condition.find(params[:id].to_i())
  @condition.notes << "<br>"
  @condition.notes << params['notes']
  @condition.update()
  redirect("wellbeing/conditions/#{@condition.id}")
end

post '/wellbeing/conditions/:id' do
  @condition = Condition.find(params[:id].to_i())
  @condition.physio_id = params['physio_id'].to_i()
  @condition.type = params['type']
  @condition.diagnosed = params['diagnosed']
  @condition.update()
  redirect("wellbeing/patients/#{@condition.patient.id}")
  # erb(:"conditions/show")
end


get '/wellbeing/conditions/new' do
  @patients = Patient.all()
  @physios = Physio.all()
  erb(:"conditions/new")
end

get '/wellbeing/conditions/:id/edit' do
  @condition = Condition.find(params[:id])
  @physios = Physio.all()
  erb(:"conditions/edit")
end

post '/wellbeing/conditions' do
  @condition = Condition.new(params)
  @condition.save()
  redirect("/wellbeing/patients/#{params['patient_id'].to_i()}")
end

get '/wellbeing/conditions/:id' do
  @condition = Condition.find(params[:id])
  @return_patient = "return_patient"
  erb(:"conditions/show")
end
