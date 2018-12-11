require('sinatra')
require('sinatra/contrib/all')
require('date')

require_relative('./controllers/member_controller.rb')
require_relative('./controllers/lesson_controller.rb')
require_relative('./controllers/member_lesson_controller.rb')
also_reload('./models/*')

get '/' do
  erb(:home)
end
