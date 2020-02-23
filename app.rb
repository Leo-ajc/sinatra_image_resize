Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load all the environment specific gems

set :port, 3333
set :bind, '0.0.0.0'

get '/info' do
  content_type :json
  # MiniMagick::Image.open uses Tempfile, no file system access.
  MiniMagick::Image.open(params['url']).data.to_json
end

get '/thumbnail' do
  # MiniMagick::Image.open uses Tempfile, no file system access.
  image = MiniMagick::Image.open params['url']
  image.resize "25%"
  send_file open(image.path,
    type: image.data["mimeType"],
    disposition: 'inline'
  )
end

get '/' do
  'Hello World!'
end
