# frozen_string_literal: true

# Extracting behavior for compution of
# dependent values
module RedisCloudAutoUpgrade::DependentValues
  private

  def current_redis_mem_usage_megab
    @current_redis_mem_usage_megab ||=
      current_redis_mem_usage / 1_000_000
  rescue StandardError
    0
  end

  def current_redis_mem_usage_percent
    @current_redis_mem_usage_percent ||=
      current_redis_mem_usage * 100 / currently_available_memory
  rescue StandardError
    0
  end

  def treshhold_in_percent
    @treshhold_in_percent ||=
      (config.treshhold * 100).round
  end
end
