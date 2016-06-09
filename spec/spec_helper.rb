
# frozen_string_literal: true
require_relative '../lib/redis_cloud_auto_upgrade'
HerokuAPI = RedisCloudAutoUpgrade::HerokuAPI

PROJECT_ROOT = File.expand_path '../..', __FILE__
Dir[File.join(PROJECT_ROOT, 'spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |c|
  c.filter_run wip: true
  c.run_all_when_everything_filtered = true
end
