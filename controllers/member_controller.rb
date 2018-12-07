require_relative ("../models/member.rb")

get '/members' do
  @members = Member.all()
  @show_members = "show_members"
  erb(:"members/index")
end

get '/members/new' do
  erb(:"members/new")
end

post "/members/:id/delete" do
  @member = Member.find(params[:id].to_i())
  @member.delete()
  erb(:"members/delete")
end





post '/members' do
  @member = Member.new(params)
  @member.save()
  erb(:"members/create")
end
