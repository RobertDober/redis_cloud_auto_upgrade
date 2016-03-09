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
             # Upgrade as soon as 50% of the available 
             conf.treshhold = 0.5

             # Logging is provided if enabled as follows
             conf.logger = Rails.logger

             # Any action can be taken in case an upgrade is actually done
             conf.on_upgrade do | upgrade_info |
                # upgrade_info is a Hash see below for more information
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
