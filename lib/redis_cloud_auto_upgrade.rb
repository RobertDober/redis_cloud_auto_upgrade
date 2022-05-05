# frozen_string_literal: true

require_relative './redis_cloud_auto_upgrade/version'
require_relative './redis_cloud_auto_upgrade/exceptions'
require_relative './redis_cloud_auto_upgrade/configuration'
require_relative './redis_cloud_auto_upgrade/dependent_values'
require_relative './redis_cloud_auto_upgrade/class_methods'

require_relative './redis_cloud_auto_upgrade/heroku_api'

require 'redis'

# See README.md for details
class RedisCloudAutoUpgrade
  include self::DependentValues
  extend  self::ClassMethods

  def initialize
    @config = Configuration.new
  end

  def configure(config)
    @config.configure config
    self
  end

  def current_redis_cloud_plan
    @current_redis_cloud_plan ||=
      HerokuAPI.current_redis_cloud_plan(**heroku_params)
  end

  # Memoize from lab42_core gem?
  def current_redis_mem_usage
    return @__current_redis_mem_usage__ if @__current_redis_mem_usage__

    redis_instance = config.redis_instance || Redis.current
    @__current_redis_mem_usage__ = redis_instance.info['used_memory'].to_i
  end

  def needs_to_upgrade?
    current_redis_mem_usage >= (currently_available_memory * config.treshhold)
  end

  def potential_upgrade!
    raise IllegalConfiguration, config.errors_human_readable unless config.valid?

    do_potential_upgrade!
  end

  private

  attr_reader :config

  def currently_available_memory
    @currently_available_memory ||=
      HerokuAPI.currently_available_memory(
        **config.only(:heroku_api_key, :heroku_app_name)
      )
  end

  def do_potential_upgrade!
    if needs_to_upgrade?
      do_upgrade!
      true
    else
      info_no_upgrade
      false
    end
  end

  def do_upgrade!
    old_plan = current_redis_cloud_plan
    new_plan = HerokuAPI.upgrade_plan!(
      **config.only(:heroku_api_key, :heroku_app_name)
    )
    log_upgrade old_plan, new_plan
    config.on_upgrade&.call(update_data(old_plan, new_plan))
  end

  def log_upgrade(old_plan, new_plan)
    info <<~UPGRADE
      upgraded RedisCloud plan for app: #{config.heroku_app_name}
      mem usage was approximately #{current_redis_mem_usage / 1_000_000}MB
      old_plan was #{old_plan}
      new_plan is #{new_plan}
    UPGRADE
  end

  def heroku_params
    @heroku_params ||=
      config.only(:heroku_api_key, :heroku_app_name)
  end

  def info(str)
    return unless config.logger

    config.logger.info([self.class.name, str].join(' '))
  end

  def info_no_upgrade
    msg = format(
      'no upgrade needed %s mem usage %dMB or %d%%, treshhold: %d%%, current plan: %s',
      config.heroku_app_name,
      current_redis_mem_usage_megab,
      current_redis_mem_usage_percent,
      treshhold_in_percent,
      current_redis_cloud_plan
    )
    info msg
  end

  def update_data(old_plan, new_plan)
    OpenStruct.new(
      old_plan: old_plan,
      new_plan: new_plan,
      upgraded_at: Time.now,
      mem_usage: current_redis_mem_usage,
      mem_usage_in_percent: current_redis_mem_usage_percent,
      treshhold_in_percent: treshhold_in_percent
    )
  end
end # class RedisCloudAutoUpgrade
