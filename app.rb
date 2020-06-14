require 'sinatra'

set :bind, '0.0.0.0'

get '/' do
  "This is dogapore\n"
end

post '/' do
  # request.body.rewind
  if request.body.to_s == ""
    logger.info "no body"
    return "no body"
  end
  data = JSON.parse request.body.read
  logger.info "#{data}"
  "Hello #{data}!\n"
end
