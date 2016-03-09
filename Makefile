test:
	bundle exec rspec

run_test: test
	bundle exec rubocop

dev_test: test
	bundle exec rubocop -a
