Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load all the environment specific gems

set :show_exceptions, false # Required to handle MiniMagick::Invalid in production mode.
set :port, 3333
set :bind, '0.0.0.0'

require './lib/parameter_validation'
before do
  # Every endpoint requires the param 'url'
  ParameterValidation.valid_url!(params['url'])
end

get '/info' do
  content_type :json
  MiniMagick::Image.open(params['url']).data.to_json
end

get '/thumbnail' do
  image = MiniMagick::Image.open params['url']
  image.resize "25%"
  send_file open(image.path,
    type: image.data["mimeType"],
    disposition: 'inline'
  )
end

error MiniMagick::Invalid do
  status 400
  body "400 Bad Request. Invalid image: '#{env['sinatra.error'].message}'"
end

error OpenURI::HTTPError do
  # OpenURI::HTTPError is from MiniMagick::Image.open.
  # MiniMagick requires OpenURI.

  # When a valid params['url'] leads to a 404 response.
  # The params['url'] was bad. This is a bad request
  # from the client => 400 error.
  status 400
  body "400 Bad Request. Requested resource '#{params['url']}' is unavailable."
end

error ParameterValidation::Error do
  # Badly formed URL passed as a param.
  status 400
  body '400 Bad Request. Absent or malformed parameters.'
end
