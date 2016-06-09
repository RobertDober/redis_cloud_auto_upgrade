# frozen_string_literal: true
RSpec.configure do |config|
  config.before(:example, type: :functional) do
    @heroku_api_key = ENV['HEROKU_API_KEY'] || raise('need to set the env variable HEROKU_API_KEY for this test')
    @heroku_app_name = 'fcv-experiments'
    @heroku_params =
      {
        heroku_app_name: @heroku_app_name,
        heroku_api_key: @heroku_api_key
      }
  end
end
