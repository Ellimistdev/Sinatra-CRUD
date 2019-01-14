# Sinatra CRUD

This project models a Movie reviews domain with User registration, authentication, and the following relationships: 
![Model of Database](https://cdn.buttercms.com/zKzZqfr4TCd7fL26dbPQ)

## Installation

Clone the repo and install dependencies

```bash
$ git clone https://github.com/endotnick/Sinatra-CRUD.git
$ bundle install
```

Migrate and Seed dev DB:

```bash
$ rake db:migrate
$ rake db:seed
```

Sessions are enabled through Sinatra, so you'll need to either set an environment variable `SESSION_SECRET` on your system, or add it to a `.env` file at the root of the project. The [dotenv](https://github.com/bkeepers/dotenv) gem is included in development and should automatically pick up your `.env` file.

## Development

After installation, run 

```bash
$ rake db:migrate SINATRA_ENV=test
```
 to migrate the testing db,
 
```bash
$ rspec
```
to run the tests, and


```bash
$ shotgun
```
to launch the dev server.   
The app should be running on `localhost:9393` by default


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/endotnick/Sinatra-CRUD. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The code is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sinatra-CRUD project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/endotnick/Sinatra-CRUD/blob/master/CODE_OF_CONDUCT.md).
