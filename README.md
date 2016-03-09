# redis_cloud_auto_upgrade

## Summary

A gem to allow to automatically upgrade your Redis Cloud Addon on Heroku (via Heroku's platform API)
in case a certain memory usage treshold is reached.

The following can be configured

- Heroku app and addon
- Heroku's API key
- Treshold

Typically it will be used in a background job.
 
**N.B.**

RedisCloud plan data is hardcoded into the gem for now.

## Usage


```ruby
    require 'redis_cloud_auto_upgrade'

    # E.g. in a Sidekiq Worker

    def rcau
       @__rcau__ ||=
        RedisCloudAutoUpgrade
          .new do | conf |
             # API key for the Heroku API
             conf.heroku_api_key = "a88a8aa8-a8a8-4b57-a8aa-8888aa8888aa"

             # Id of addon, which must be a rediscloud addon_service
             conf.redis_cloud_id = "4ceaf719-8a4b-4b8b-8dcf-7852fa79ec44"

             # Upgrade as soon as 50% of the available memory is used
             conf.treshhold = 0.5

             # Logging is provided if enabled as follows
             conf.logger = Rails.logger

             # Any action can be taken in case an upgrade is actually done
             conf.on_upgrade do | upgrade_info |
                # upgrade_info is a Hash see below for more information
                ...
             end
          end
    end

    def perform
      rcau.potential_upgrade! 
    end 
```

The following information is available in the `upgrade_info` Hash

```ruby
    {
      upgraded_at: DateTime,
      old_plan: "redis:100",
      new_plan: "redis:200",
      actual_mem_usage_in_percent: 65, # Mem usage that triggered the upgrade
    }
```

## Dependencies

* [Redis](https://github.com/redis/redis-rb)

* [PlatformAPI](https://github.com/heroku/platform-api)

## Copyright

MIT, c.f. [LICENSE](LICENSE)
