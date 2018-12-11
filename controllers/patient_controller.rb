require_relative ("../models/patient.rb")
require_relative ("../models/physio.rb")
require_relative ("../models/condition.rb")
require_relative ("../models/member.rb")
require_relative ("../models/member_lesson.rb")

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

post '/wellbeing/patients/:id/resolve' do
  @condition = Condition.find(params[:condition_id].to_i())
  @condition.resolve()
  redirect("wellbeing/patients/#{params[:patient_id].to_i()}")
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
  @patient = Patient.find(params[:id].to_i())
  @conditions = @patient.conditions
  if (params['member'] == "false")
    if (params['membership'] == 'standard')
      @member_id = Member.new('name' => params['patient_name'], 'member' => false).save()

      Patient.new({'id' => params[:id], 'patient_name' => params['patient_name'], 'member_id' => @member_id}).update()
    elsif (params['membership'] == 'premium')
      @member_id = Member.new('name' => params['patient_name'], 'premium' => true).save()
      Patient.new({'id' => params[:id], 'patient_name' => params['patient_name'], 'member_id' => @member_id}).update()
    elsif (params['membership'] == 'no')
      Patient.new({'id' => params[:id], 'patient_name' => params['patient_name']}).update()
    end
  elsif (params['member'] == "true")
    if (params['membership'] == 'standard')
      if (@patient.premium == true)
        @member = Member.find(@patient.member_id)
        @member.name = params['patient_name']
        @member.premium = false
        @member.update()
      end
      @patient.update
    elsif (params['membership'] == 'premium')
      @member_id = Patient.find(params[:id].to_i()).member_id
      if (@patient.premium == false)
        @member = Member.find(@member_id)
        @member.name = params['patient_name']
        @member.premium = true
        @member.update()
      end
      Patient.new({'id' => params[:id], 'patient_name' => params['patient_name'], 'member_id' => @member_id}).update()
    elsif (params['membership'] == 'no')
      @member_id = Patient.find(params[:id].to_i()).member_id
      @member = Member.find(@member_id)
      @member.delete()
      Patient.new({'id' => params[:id], 'patient_name' => params['patient_name']}).update()
    end
  end
  erb(:"patients/show")
end



post '/wellbeing/patients' do
  @patient = Patient.new(params)
  @patient.save()
  erb(:"patients/create")
end

get '/wellbeing/patients/:id' do
  @patient = Patient.find(params[:id].to_i())
  # @show_added = "show_added" if (params[:show_added] == "true")
  # @show_removed = "show_removed" if (params[:show_removed] == "true")
  # @physio = params[:physio] if ((params[:show_added] == "true") || (params[:show_removed] == "true"))
  @conditions = @patient.conditions()
  erb(:"patients/show")
end
