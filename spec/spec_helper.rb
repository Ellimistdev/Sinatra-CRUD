ENV['SINATRA_ENV'] = 'test'

require_relative '../config/environment'
require 'rack/test'
require 'capybara/rspec'
require 'capybara/dsl'
require 'rack_session_access/capybara'

raise 'Migrations are pending. Run `rake db:migrate SINATRA_ENV=test` to resolve the issue.' if ActiveRecord::Migrator.needs_migration?

ActiveRecord::Base.logger = nil

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include Rack::Test::Methods
  config.include Capybara::DSL
  DatabaseCleaner.strategy = :truncation

  config.before(:suite) do
    DatabaseCleaner.clean
    load './db/seeds.rb'
  end

  config.after(:suite) do
    DatabaseCleaner.clean
  end

  config.order = 'default'
end

def app
  Rack::Builder.parse_file('config.ru').first
end

Capybara.app = app
