# frozen_string_literal: true
# Extracting behavior for compution of
# dependent values
module RedisCloudAutoUpgrade::DependentValues
  private

  def current_redis_mem_usage_megab
    @__current_redis_mem_usage_megab__ ||=
      current_redis_mem_usage / 1_000_000
  rescue
    0
  end

  def current_redis_mem_usage_percent
    @__current_redis_mem_usage_percent__ ||=
      current_redis_mem_usage * 100 / currently_available_memory
  rescue
    0
  end

  def treshhold_in_percent
    @__treshhold_in_percent__ ||=
      (config.treshhold * 100).round
  end
end
