This repo contains a finished version of the [Hartl Rails Tutorial](https://www.railstutorial.org/) which includes a basic overview of the major features of the Ruby on Rails web framework.

I've tuned the tools used based on my experience in web development, opting for usage of Factories instead of Fixtures, and using RSpec instead of MiniTest.

This repo constitutes a good starting point for creating web applications within Rails.

# Setup
- Ruby version: 2.2.5
- DB: MySQL for Development, Postgres for Prod
- `$ bundle install` to install dependencies
- `$ rails db:create db:migrate db:seed` will initialize the database with the seed data
- `$ rails s` will start the server

## Testing
- Selenium & Capybara for web mocking
- Rspec test framework
- Pry for debugging
- FactoryGirl for model generation
- `$ rspec spec/` will run the spec suite

To Do
- [ ] Integrate Devise for login
- [ ] Fortify spec suite
