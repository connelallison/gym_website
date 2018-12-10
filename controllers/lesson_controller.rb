require_relative ("../models/member.rb")
require_relative ("../models/lesson.rb")
require_relative ("../models/member_lesson.rb")

get '/gym/lessons' do
  @lessons = Lesson.all_ascending_id()
  @show_lessons = "show_lessons"
  erb(:"lessons/index")
end

get '/gym/lessons/new' do
  erb(:"lessons/new")
end

post '/gym/lessons/:id/delete' do
  @lesson = Lesson.find(params[:id].to_i())
  if (@lesson == nil); redirect('/gym/lessons'); end
  if (@lesson!= nil); @lesson.delete(); end
  erb(:"lessons/delete")
end

get '/gym/lessons/:id/edit' do
  @lesson = Lesson.find(params[:id].to_i())
  erb(:"lessons/edit")
end

post '/gym/lessons/:id/remove' do
  @member = Member.find(params[:member_id].to_i())
  @lesson = Lesson.find(params[:lesson_id].to_i())
  @show_removed = "show_removed"
  MemberLesson.delete_by_member_and_lesson((params[:member_id].to_i()), (params[:lesson_id].to_i()))
  redirect("/gym/lessons/#{@lesson.id}?show_removed=true&member=#{@member.name}")
end

post '/gym/lessons/:id/add' do
  @member = Member.find(params[:member_id].to_i())
  @lesson = Lesson.find(params[:lesson_id].to_i())
  @member_lesson = @lesson.add_member(@member)
  @member_lesson.save()
  @members = Member.all()
  @show_added = "show_added"
  redirect("/gym/lessons/#{@lesson.id}?show_added=true&member=#{@member.name}")
end

post '/gym/lessons/:id' do
  @lesson = Lesson.new(params)
  @lesson.update()
  MemberLesson.delete_ineligible()
  erb(:"lessons/update")
end

post '/gym/lessons' do
  @lesson = Lesson.new(params)
  @lesson.save()
  erb(:"lessons/create")
end

get '/gym/lessons/:id' do
  @lesson = Lesson.find(params[:id].to_i())
  @show_added = "show_added" if (params[:show_added] == "true")
  @show_removed = "show_removed" if (params[:show_removed] == "true")
  @member = params[:member] if ((params[:show_added] == "true") || (params[:show_removed] == "true"))
  @members = Member.all()
  erb(:"lessons/show")
end
