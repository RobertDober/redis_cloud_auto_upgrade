require_relative './redis_cloud_auto_upgrade/version'
require_relative './redis_cloud_auto_upgrade/configuration'

class RedisCloudAutoUpgrade

  def configure &blk
    blk.( @config )
  end

  private

  def initialize
    @config = Configuration.new
  end

  def config; @config end
end # class RedisCloudAutoUpgrade
