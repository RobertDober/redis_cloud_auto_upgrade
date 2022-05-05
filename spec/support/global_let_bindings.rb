# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:example, type: :functional) do
    @heroku_app_name = 'fcv-experiments'

    heroku_variable_expanation = [
      'To run integreation test',
      'you need to set the env variable HEROKU_API_KEY',
      'run heroku auth:token',
      "and make sure that you have access to the heroku app #{@heroku_app_name}",
      "You can change @heroku_app_name in #{__FILE__}"
    ].join("\n")

    @heroku_api_key = ENV['HEROKU_API_KEY'] || raise(heroku_variable_expanation)
    @heroku_app_name = 'fcv-experiments'
    @heroku_params =
      {
        heroku_app_name: @heroku_app_name,
        heroku_api_key: @heroku_api_key
      }
  end
end
