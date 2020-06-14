require 'sinatra'

set :bind, '0.0.0.0'

get '/' do
  request.body.rewind
  data = JSON.parse request.body.read
  "Hello #{data}!\n"
end
