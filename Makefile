test:
	bundle exec rspec

run_test: test
	bundle exec rubocop


dev_cop:
	bundle exec rubocop -a

coffee: dev_cop test
