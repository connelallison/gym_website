require_relative ("../models/member.rb")

get '/lessons' do
  @lessons = Lesson.all_ascending_id()
  @show_lessons = "show_lessons"
  erb(:"lessons/index")
end

get '/lessons/new' do
  erb(:"lessons/new")
end

post "/lessons/:id/delete" do
  @lesson = Lesson.find(params[:id].to_i())
  @lesson.delete()
  erb(:"lessons/delete")
end

get "/lessons/:id/edit" do
  @lesson = Lesson.find(params[:id].to_i())
  erb(:"lessons/edit")
end

post "/lessons/:id" do
  @lesson = Lesson.new(params)
  @lesson.update()
  erb(:"lessons/update")
end

post '/lessons' do
  @lesson = Lesson.new(params)
  @lesson.save()
  erb(:"lessons/create")
end

get '/lessons/:id' do
  @lesson = Lesson.find(params[:id].to_i())
  erb(:"lessons/show")
end
