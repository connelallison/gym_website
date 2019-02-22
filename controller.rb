require('sinatra')
require('sinatra/contrib/all') if development?
require('date')

require_relative('./controllers/member_controller.rb')
require_relative('./controllers/lesson_controller.rb')
require_relative('./controllers/member_lesson_controller.rb')
require_relative('./controllers/patient_controller.rb')
require_relative('./controllers/physio_controller.rb')
require_relative('./controllers/condition_controller.rb')


get '/' do
  erb(:home)
end
