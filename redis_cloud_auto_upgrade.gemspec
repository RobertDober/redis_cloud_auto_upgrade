$:.unshift( File.expand_path( "../lib", __FILE__ ) )
require 'lab42/core/version'
version = Lab42::Core::VERSION
Gem::Specification.new do |s|
  s.name        = 'lab42_core'
  s.version     = version
  s.summary     = 'Simple Ruby Core Module Extensions (for more see lab42_more)'
  s.description = %{Functional Access to Methods - Memoization - Extending Array, Hash, File, Enumerable with convenience methods, conceptual changes have been moved into lab42_more} 
  s.authors     = ["Robert Dober"]
  s.email       = 'robert.dober@gmail.com'
  s.files       = Dir.glob("lib/**/*.rb")
  s.files      += %w{LICENSE README.md}
  s.homepage    = "https://github.com/RobertDober/lab42_core"
  s.licenses    = %w{MIT}

  s.required_ruby_version = '>= 2.1.0'
  s.add_dependency 'forwarder2', '~> 0.2'

  s.add_development_dependency 'pry', '~> 0.10'
  s.add_development_dependency 'pry-nav', '~> 0.2'
  s.add_development_dependency 'rspec', '~> 3.2'
  s.add_development_dependency 'qed', '~> 2.9'
  s.add_development_dependency 'ae', '~> 1.8'
  # s.add_development_dependency 'lab42_tmux2', '~> 0.0'
  s.add_development_dependency 'travis-lint', '~> 2.0'
  # s.add_development_dependency 'rake', '~> 10.3'
end
