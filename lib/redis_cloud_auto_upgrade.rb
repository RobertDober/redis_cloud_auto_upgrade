require_relative './redis_cloud_auto_upgrade/version'
require_relative './redis_cloud_auto_upgrade/exceptions'
require_relative './redis_cloud_auto_upgrade/configuration'

require_relative './redis_cloud_auto_upgrade/heroku_api'

require 'redis'

# See README.md for details
class RedisCloudAutoUpgrade
  class << self
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
    @__current_redis_cloud_plan ||=
    HerokuAPI.current_redis_cloud_plan(**heroku_params)
  end

  # Memoize from lab42_core gem?
  def current_redis_mem_usage
    return @__current_redis_mem_usage__ if @__current_redis_mem_usage__
    redis_instance = config.redis_instance || Redis.current
    @__current_redis_mem_usage__ = redis_instance.info['used_memory'].to_i
  end

  def needs_to_upgrade?
    !(current_redis_mem_usage <  currently_available_memory * config.treshhold)
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

  def currently_available_memory
    @__currently_available_memory__ ||=
      HerokuAPI.currently_available_memory(
        **config.only(:heroku_api_key, :heroku_app_name))
  end

  def do_potential_upgrade!
    if needs_to_upgrade?
      do_upgrade!
      true
    else
      info "no upgrade needed #{config.heroku_app_name} mem usage #{current_redis_mem_usage / 1_000_000}MB"
      false
    end
  end

  def do_upgrade!
    old_plan = current_redis_cloud_plan
    new_plan = HerokuAPI.upgrade_plan!(
      **config.only(:heroku_api_key, :heroku_app_name)
    )
    log_upgrade old_plan, new_plan
    config.on_upgrade.call(update_data(old_plan, new_plan)) if config.on_upgrade
  end

  def log_upgrade(old_plan, new_plan)
    info <<-EOS
upgraded RedisCloud plan for app: #{config.heroku_app_name}
mem usage was approximately #{current_redis_mem_usage / 1_000_000}MB
old_plan was #{old_plan}
new_plan is #{new_plan}
        EOS
  end

  def heroku_params
    @__heroku_params__ ||=
      config.only(:heroku_api_key, :heroku_app_name)
  end

  def info(str)
    return unless config.logger
    config.logger.info([self.class.name, str].join(' '))
  end

  def mem_usage_in_percent
    @__mem_usage_in_percent__ ||=
      current_redis_mem_usage * 100 / currently_available_memory
  end

  def update_data(old_plan, new_plan)
    OpenStruct.new(
      old_plan: old_plan,
      new_plan: new_plan,
      upgraded_at: Time.now,
      mem_usage: current_redis_mem_usage,
      mem_usage_in_percent: mem_usage_in_percent,
      treshhold_in_percent: treshhold_in_percent
    )
  end

  def treshhold_in_percent
    @__treshhold_in_percent__ ||=
      (config.treshhold * 100).round
  end
end # class RedisCloudAutoUpgrade
