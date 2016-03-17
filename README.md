# redis_cloud_auto_upgrade

## Summary

A gem to allow to automatically upgrade your Redis Cloud Addon on Heroku (via Heroku's platform API)
in case a certain memory usage treshold is reached.

The following can be configured

- Heroku app and addon
- Heroku's API key
- Treshold

Typically it will be used in a background job.
 
## Gotchas

* RedisCloud plan data is hardcoded into the gem for now.

* Only the current Redis instance is used to determine the used memory.

## Usage

### Official API

The following is the defined API as protected by semantic version and being **threadsafe**.

```ruby
    require 'redis_cloud_auto_upgrade'

    # E.g. in a Sidekiq Worker

    def perform
      RedisCloudAutoUpgrade.potential_upgrade!(
        # API key for the Heroku API                              required
        heroku_api_key: "a88a8aa8-a8a8-4b57-a8aa-8888aa8888aa",
 
        # Id of addon, which must be a rediscloud addon_service   required
        redis_cloud_id: = "4ceaf719-8a4b-4b8b-8dcf-7852fa79ec44"
 
        # Upgrade as soon as 50% of the available memory is used  defaults to 0.5
        treshhold: 0.5
 
        # Logging is provided if enabled as follows               optional
       logger: Rails.logger
        ) do | upgrade_info |
          # Callback in case an upgrade is actually done            optional
          # upgrade_info is a Hash see below for more information
             ...
        end
    end
```


Its return value is false if no upgrade was applied, true otherwise.

However to get more information you can provide a block which will be called with an `OpenStruct` instance, containing the following values

```ruby
      {
        updated_at: DateTime,
        old_plan: "rediscloud:100",
        new_plan: "rediscloud:200",
        mem_usage: 12_345_678,           # in bytes
        mem_usage_in_percent: 65,        # Mem usage that triggered the upgrade
        treshhold_in_percent: 50         # Mem usage >= treshhold triggers upgrades
      }
```

### Inofficial API

Not protected by semantic versioning and **not threadsafe** is the API of the underlying object.

It is however very useful for experimenting:

```ruby
    

  rcau = RedisCloudAutoUpgrade.new
  rcau.configure(heroku_api_key: 'aaaaaaaa...', heroku_app_name: 'myapp').configure(treshhold: 0.2) # 20%

  rcau.needs_to_upgrade?    #-> true
  rcau.configure(treshhold: 0.8)
  rcau.needs_to_upgrade?    #-> false

  rcau.configure(logger: Logger.new($stdout))
  
  rcau.current_redis_cloud_plan #-> rediscloud:100 
  # Memoized value create a new object if  interested in changing values

  rcau.current_redis_mem_usage  #-> 200300400 bytes, Memoized too
```

## Developer's Guide

### Testing

We are testing with VCR and in order to setup the cassettes we upgrade a plan to `rediscloud:100` causing some cost.

If you want to test here is how to do it:

N.B. **Any time you test without the VCR cassettes you will spend some cents on the RedisCloud plan upgrade**

* Setup the two env variables `$HEROKU_APP_NAME` and `$HEROKU_API_KEY` correctly.

* Run the tests (this will fill `fixtures/vcr_cassettes` in your local copy, these files are not versioned as they contain your API KEY.)

* As you have just upgraded your Redis Cloud Plan to `rediscloud:100` do downgrade it to minimize the costs

## Dependencies

* [Redis](https://github.com/redis/redis-rb)

* [PlatformAPI](https://github.com/heroku/platform-api)

## References

* [Heroku Platform API / Addons](https://devcenter.heroku.com/articles/platform-api-reference#add-on)

## Copyright

MIT, c.f. [LICENSE](LICENSE)

## Authors

Guillaume Leseur
Robert Dober
