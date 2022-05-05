# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))
require 'redis_cloud_auto_upgrade/version'
version = RedisCloudAutoUpgrade::VERSION
Gem::Specification.new do |s|
  s.name        = 'redis_cloud_auto_upgrade'
  s.version     = version
  s.summary     = 'Gem permits to auto upgrade your Redis Cloud plan when a certain memory usage treshold is reached'
  s.description = %(Gem permits to auto upgrade your Redis Cloud plan when a certain memory usage treshold is reached)
  s.authors     = ['Robert Dober']
  s.email       = 'robert.dober@gmail.com'
  s.files       = Dir.glob('lib/**/*.rb')
  s.files      += %w[LICENSE README.md]
  s.homepage    = 'https://github.com/Facilecomm/redis_cloud_auto_upgrade'
  s.licenses    = %w[MIT]

  s.required_ruby_version = '>= 2.7.4'
  s.add_dependency 'platform-api', '~> 3.3.0'
  s.add_dependency 'redis', '~> 4.6'

  s.add_development_dependency 'pry-byebug', '~> 3.9'
  s.add_development_dependency 'rspec', '~> 3.11'
  s.add_development_dependency 'rubocop', '~> 0.93.1'
  s.add_development_dependency 'rubocop-rails', '~> 2.4'
  s.add_development_dependency 'timecop', '~> 0.9.5'
  s.add_development_dependency 'vcr', '~> 6.1.0'
  s.add_development_dependency 'webmock', '~> 3.14'
end
