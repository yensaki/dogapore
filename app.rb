require 'sinatra'

set :bind, '0.0.0.0'

get '/' do
  # request.body.rewind
  if request.body.to_s == ""
    return "no body"
  end
  data = JSON.parse request.body.read
  "Hello #{data}!\n"
end
