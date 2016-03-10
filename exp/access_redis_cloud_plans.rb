require 'platform-api'
require 'pp'

heroku = PlatformAPI.connect ENV['HEROKU_API_KEY']
redis_cloud = heroku.addon_service.list.find { |service| service['human_name'] == 'Redis Cloud' }
redis_cloud_id = redis_cloud['id']
redis_cloud_addon_service = heroku.addon_service.info(redis_cloud_id)

redis_cloud_addon = heroku.addon.list_by_app('fcv-experiments').find { |addon| addon['addon_service']['name'] == 'rediscloud' rescue nil }
