require 'sinatra'
require 'base64'
require 'google/cloud/storage'
require 'fileutils'
require 'cherry_picking_moments'

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

  logger.info  File.size(filepath)
  picking_movie = CherryPickingMoments.movie(filepath)

  logger.info "#{picking_movie.images.size}"

  picking_movie.images.each.with_index(1) do |image, index|
    File.open(image.filepath) do |file|
      filename = "#{index}#{File.extname(file)}"
      filepath = File.join(
        "sliced/images/",
        decoded_data["uid"],
        "#{image.following_distance}/#{filename}"
      )
      bucket.create_file(file, filepath)
      logger.info "#{image.following_distance}/#{filename}"
    end
  end

  "OK\n"
end
