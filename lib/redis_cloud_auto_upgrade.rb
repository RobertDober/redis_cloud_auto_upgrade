require_relative './redis_cloud_auto_upgrade/version'
require_relative './redis_cloud_auto_upgrade/exceptions'
require_relative './redis_cloud_auto_upgrade/configuration'

require_relative './heroku_api'

require 'redis'

# See README.md for details
class RedisCloudAutoUpgrade
  class << self
    def current_redis_cloud_plan(conf)
      HerokuAPI.redis_cloud_plan(conf)
    end

    def potential_upgrade!(conf, &blk)
      updated_conf = conf.merge(on_upgrade: blk)
      new
        .configure(updated_conf)
        .potential_upgrade!
    end
  end # class << self

  def configure(config)
    @config.configure config
    self
  end

  def current_redis_cloud_plan
    HerokuAPI.current_redis_cloud_plan(**config.only(:heroku_app_name, :heroku_api_key))
  end

  # Memoize from lab42_core gem?
  def current_redis_mem_usage
    return @current_redis_mem_usage if @current_redis_mem_usage
    redis_instance = config.redis_instance || Redis.current
    @current_redis_mem_usage = redis_instance.info['used_memory'].to_i
  end

  def needs_to_upgrade?
    !(current_redis_mem_usage <
      HerokuAPI.currently_available_memory(
        **config.only(:heroku_api_key, :heroku_app_name)
      ) * config.treshhold)
  end

  def potential_upgrade!
    if config.valid?
      do_potential_upgrade!
    else
      fail IllegalConfiguration, config.errors_human_readable
    end
  end

  private

  def initialize
    @config = Configuration.new
  end

  attr_reader :config

  def do_potential_upgrade!
    if needs_to_upgrade?
      HerokuAPI.upgrade_to_plan!(
        **config.only(:heroku_api_key, :heroku_app_name)
      )
      log <<-EOS
        upgraded #{config.only(:heroku_app_name)} mem usage was #{current_redis_mem_usage / 1_000_000}MB
        old_plan: #{old_plan}
        new_plan: #{new_plan}
      EOS
      config.on_upgrade.( self ) if config.on_upgrade
    else
      log "no upgrade needed #{config.only(:heroku_app_name)} mem usage #{current_redis_mem_usage / 1_000_000}MB"
    end
  end

  def log str
    # Coming soon
  end
end # class RedisCloudAutoUpgrade
