require './config/environment'

raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.' if ActiveRecord::Migrator.needs_migration?

use UsersController
run ApplicationController
use ReviewsController
use MoviesController
