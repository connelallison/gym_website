require_relative ("../models/patient.rb")
require_relative ("../models/physio.rb")
require_relative ("../models/condition.rb")

get '/wellbeing/patients' do
  @patients = Patient.all_ascending_id()
  @show_patients = "show_patients"
  erb(:"patients/index")
end

get '/wellbeing/patients/new' do
  erb(:"patients/new")
end

post '/wellbeing/patients/:id/delete' do
  @patient = Patient.find(params[:id].to_i())
  if (@patient == nil); redirect('/wellbeing/patients'); end
  if (@patient!= nil); @patient.delete(); end
  erb(:"patients/delete")
end

get '/wellbeing/patients/:id/edit' do
  @patient = Patient.find(params[:id].to_i())
  erb(:"patients/edit")
end

post '/wellbeing/patients/:id/remove' do
  @patient = Patient.find(params[:patient_id].to_i())
  @physio = Physio.find(params[:physio_id].to_i())
  @show_removed = "show_removed"
  Condition.delete_by_patient_and_physio((params[:patient_id].to_i()), (params[:physio_id].to_i()))
  # redirect("/wellbeing/patients/#{@patient.id}?show_removed=true&physio=#{@physio.course}")
end

post '/wellbeing/patients/:id/add' do
  @patient = Patient.find(params[:patient_id].to_i())
  @physio = Physio.find(params[:physio_id].to_i())
  @patient_physio = @patient.add_physio(@physio)
  @patient_physio.save()
  @physios = Physio.all()
  @show_added = "show_added"
  redirect("/wellbeing/patients/#{@patient.id}?show_added=true&physio=#{@physio.course}")
end

post '/wellbeing/patients/:id' do
  @patient = Patient.new(params)
  @patient.update()
  erb(:"patients/update")
end


post '/wellbeing/patients' do
  @patient = Patient.new(params)
  @patient.save()
  erb(:"patients/create")
end

get '/wellbeing/patients/:id' do
  @patient = Patient.find(params[:id].to_i())
  @show_added = "show_added" if (params[:show_added] == "true")
  @show_removed = "show_removed" if (params[:show_removed] == "true")
  @physio = params[:physio] if ((params[:show_added] == "true") || (params[:show_removed] == "true"))
  @physios = Physio.all()
  erb(:"patients/show")
end
