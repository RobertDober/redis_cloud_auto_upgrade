require 'platform-api'
# A function wrapper accessing the Heroku Platform API in a functional way
module HerokuAPI
  module_function

  def current_redis_cloud_plan(heroku_api_key:, heroku_app_name:)
    heroku(heroku_api_key)
      .addon
      .list_by_app(heroku_app_name)
      .find(&select_redis_cloud_addon)['plan']['name']
  end

  def heroku(api_key)
    PlatformAPI.connect api_key
  end

  def select_redis_cloud_addon
    lambda  do |addon|
      begin
        addon['addon_service']['name'] == 'rediscloud'
      rescue
        nil
      end
    end
  end
end
