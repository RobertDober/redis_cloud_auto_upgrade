require 'platform-api'
# A function wrapper accessing the Heroku Platform API in a functional way
module HerokuAPI
  module_function

  def available_memory(plan)
    plan_memory
      .fetch(plan) do
        fail ArgumentError, "the plan #{plan.inspect} does not exist"
      end
  end

  def current_redis_cloud_plan(heroku_api_key:, heroku_app_name:)
    heroku(heroku_api_key)
      .addon
      .list_by_app(heroku_app_name)
      .find(&select_redis_cloud_addon)['plan']['name']
  end

  def currently_available_memory(heroku_api_key:, heroku_app_name:)
    available_memory(
      current_redis_cloud_plan(
        heroku_api_key: heroku_api_key, heroku_app_name: heroku_app_name))
  end

  def heroku(api_key)
    PlatformAPI.connect api_key
  end

  def next_plan(plan)
    plan_transitions
      .fetch(plan) do
        fail ArgumentError, "the plan #{plan.inspect} does not exist or cannot be upgraded"
      end
  end

  # rubocop:disable Metrics/MethodLength
  def plan_transitions
    {
      'rediscloud:30' => 'rediscloud:100',
      'rediscloud:100' => 'rediscloud:250',
      'rediscloud:250' => 'rediscloud:500',
      'rediscloud:500' => 'rediscloud:1_000',
      'rediscloud:1_000' => 'rediscloud:2_500',
      'rediscloud:2_500' => 'rediscloud:5_000',
      'rediscloud:5_000' => 'rediscloud:10_000',
      'rediscloud:10_000' => 'rediscloud:15_000',
      'rediscloud:15_000' => 'rediscloud:20_000',
      'rediscloud:20_000' => 'rediscloud:25_000',
      'rediscloud:25_000' => 'rediscloud:50_000'
    }
  end

  def plan_memory
    {
      'rediscloud:30' => 30_000_000,
      'rediscloud:100' => 100_000_000,
      'rediscloud:250' => 250_000_000,
      'rediscloud:500' => 500_000_000,
      'rediscloud:1000' => 1_000_000_000,
      'rediscloud:2500' => 2_500_000_000,
      'rediscloud:5000' => 5_000_000_000,
      'rediscloud:10000' => 10_000_000_000,
      'rediscloud:15000' => 15_000_000_000,
      'rediscloud:20000' => 20_000_000_000,
      'rediscloud:25000' => 25_000_000_000,
      'rediscloud:50000' => 50_000_000_000
    }
  end

  def select_redis_cloud_addon
    lambda  do |addon|
      begin
        addon['addon_service']['name'] == 'rediscloud'
      rescue
        nil
      end
    end
  end
end
