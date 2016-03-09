$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
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
  s.files      += %w(LICENSE README.md)
  s.homepage    = 'https://github.com/RobertDober/lab42_core'
  s.licenses    = %w(MIT)

  s.required_ruby_version = '>= 2.2.0'
  s.add_dependency 'redis', '~> 3.2'
  s.add_dependency 'platform-api', '~> 0.5'

  s.add_development_dependency 'pry-byebug', '~> 3.3'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'rubocop', '= 0.29.1'
  s.add_development_dependency 'sidekiq', '~> 3.3'
  s.add_development_dependency 'travis-lint', '~> 2.0'
end
