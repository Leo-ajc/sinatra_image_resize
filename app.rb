Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load all the environment specific gems

set :port, 3333
set :bind, '0.0.0.0'

get '/' do
  'Hello World!'
end
