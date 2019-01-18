require './config/environment'

raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.' if ActiveRecord::Migrator.needs_migration?

# for submitting forms w/ patch, delete etc.
use Rack::MethodOverride
use MoviesController
use ReviewsController
use UsersController
use RackSessionAccess::Middleware if ENV['SINATRA_ENV'] == 'test'
run ApplicationController
