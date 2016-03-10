require_relative './redis_cloud_auto_upgrade/version'
require_relative './redis_cloud_auto_upgrade/exceptions'
require_relative './redis_cloud_auto_upgrade/configuration'

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
  
  def current_redis_mem_usage
    Redis.current.info["used_memory"].to_i
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
end # class RedisCloudAutoUpgrade
