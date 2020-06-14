require 'sinatra'
require 'base64'
require 'google/cloud/storage'

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
  decoded_data = JSON.parse(Base64.decode64(data))
  logger.info "#{decoded_data}"

  storage = Google::Cloud::Storage.new(project_id: "saki-185412")
  bucket = storage.bucket("juucy")
  file = bucket.file(decoded_data["filename"])
  filepath = "/tmp/#{file.name}"
  file.download(filepath)
  logger.info "#{File.size(filepath)}"
  "Hello #{File.size(filepath)}!\n"
end
