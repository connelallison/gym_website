require_relative ("../models/member.rb")

get '/members' do
  @members = Member.all()
  @show_members = "show_members"
  erb(:"members/index")
end
