ENV['RACK_ENV'] = 'test'
require 'webmock/rspec'
require 'rack/test'

Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load all the environment specific gems

RSpec.configure do |config|
  config.include WebMock::API
  config.include Rack::Test::Methods
end
