require_relative ("../models/member.rb")
require_relative ("../models/lesson.rb")
require_relative ("../models/member_lesson.rb")

get '/gym/members' do
  @members = Member.all_ascending_id()
  @show_members = "show_members"
  erb(:"members/index")
end

get '/gym/members/new' do
  erb(:"members/new")
end

post '/gym/members/:id/delete' do
  @member = Member.find(params[:id].to_i())
  if (@member == nil); redirect('/gym/members'); end
  if (@member!= nil); @member.delete(); end
  erb(:"members/delete")
end

get '/gym/members/:id/edit' do
  @member = Member.find(params[:id].to_i())
  erb(:"members/edit")
end

post '/gym/members/:id/remove' do
  @member = Member.find(params[:member_id].to_i())
  @lesson = Lesson.find(params[:lesson_id].to_i())
  @show_removed = "show_removed"
  MemberLesson.delete_by_member_and_lesson((params[:member_id].to_i()), (params[:lesson_id].to_i()))
  redirect("/gym/members/#{@member.id}?show_removed=true&lesson=#{@lesson.course}")
end

post '/gym/members/:id/add' do
  @member = Member.find(params[:member_id].to_i())
  @lesson = Lesson.find(params[:lesson_id].to_i())
  @member_lesson = @member.add_lesson(@lesson)
  @member_lesson.save()
  @lessons = Lesson.all()
  @show_added = "show_added"
  redirect("/gym/members/#{@member.id}?show_added=true&lesson=#{@lesson.course}")
end

post '/gym/members/:id' do
  @member = Member.new(params)
  @member.update()
  MemberLesson.delete_ineligible()
  erb(:"members/update")
end


post '/gym/members' do
  @member = Member.new(params)
  @member.save()
  erb(:"members/create")
end

get '/gym/members/:id' do
  @member = Member.find(params[:id].to_i())
  @show_added = "show_added" if (params[:show_added] == "true")
  @show_removed = "show_removed" if (params[:show_removed] == "true")
  @lesson = params[:lesson] if ((params[:show_added] == "true") || (params[:show_removed] == "true"))
  @lessons = Lesson.all()
  erb(:"members/show")
end
