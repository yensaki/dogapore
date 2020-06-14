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

  dest_dir = "/tmp/images"
  FileUtils.mkdir_p(dest_dir)
  logger.info dest_dir

  picking_movie = CherryPickingMoments.movie(filepath)

  picking_movie.images.each.with_index(1) do |image, index|
    File.open(image.filepath) do |file|
      filename = "#{index}#{File.extname(file)}"
      bucket.create_file(file, "#{image.following_distance}/#{filename}")
      logger.info "#{image.following_distance}/#{filename}"
    end
  end

  "OK\n"
end
