require_relative ("../models/member.rb")
require_relative ("../models/lesson.rb")
require_relative ("../models/member_lesson.rb")

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

post "/lessons/:id/remove" do
  MemberLesson.delete_by_member_and_lesson((params[:member_id].to_i()), (params[:lesson_id].to_i()))
  erb(:"lessons/remove")
end

post "/lessons/:id/add" do
  @member = Member.find(params[:member_id].to_i())
  @lesson = Lesson.find(params[:lesson_id].to_i())
  @member_lesson = @lesson.add_member(@member)
  @member_lesson.save()
  @members = Member.all()
  erb(:"lessons/add")
end

post "/lessons/:id" do
  @lesson = Lesson.new(params)
  @lesson.update()
  MemberLesson.delete_ineligible()
  erb(:"lessons/update")
end

post '/lessons' do
  @lesson = Lesson.new(params)
  @lesson.save()
  erb(:"lessons/create")
end

get '/lessons/:id' do
  @lesson = Lesson.find(params[:id].to_i())
  @members = Member.all()
  erb(:"lessons/show")
end
