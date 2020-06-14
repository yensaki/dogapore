require 'sinatra'
require 'base64'

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
  json = JSON.parse(request.body.read)
  data = json["message"]["data"]
  decoded_data = Base64.decode64(data)
  logger.info "#{decoded_data}"
  "Hello #{decoded_data}!\n"
end
