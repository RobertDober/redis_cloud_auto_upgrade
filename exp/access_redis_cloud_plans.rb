require 'platform-api'
require 'pp'

heroku = PlatformAPI.connect_oauth ENV['HEROKU_API_KEY']
redis_cloud = heroku.addon_service.list.find { |service| service['human_name'] == 'Redis Cloud' }
redis_cloud_id = redis_cloud['id']
redis_cloud_addon_service = heroku.addon_service.info(redis_cloud_id)

redis_cloud_addon = heroku.addon.list_by_app('fcv-experiments').find do |addon|
  begin
                                                             addon['addon_service']['name'] == 'rediscloud'
                                                           rescue
                                                             nil
                                                           end
end

pp redis_cloud_addon

info = heroku.addon.info('cf381050-415a-4917-bc3d-d500e3cbb550')
pp info

plan = begin
         info['plan']['name']
       rescue
         nil
       end
p plan

# List all Plans of an Addon of an Application
plans = heroku.plan.list('rediscloud')
# id of free plan ;) : ffea926b-cb2d-412d-9a75-0ca73b95ea61
heroku.addon.update('fcv-experiments', 'rediscloud:100', plan: 'ffea926b-cb2d-412d-9a75-0ca73b95ea61')
# id of 100M plan    : 6e23b725-bf2b-4f03-9194-865be026eac8
heroku.addon.update('fcv-experiments', 'rediscloud:30', plan: '6e23b725-bf2b-4f03-9194-865be026eac8')
