class RedisCloudAutoUpgrade
  Configuration = Struct.new(
    :on_upgrade,
    :heroku_api_key,
    :treshhold,
    :logger,
    :redis_cloud_id
  ) do
  end
end

