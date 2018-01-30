source 'https://rubygems.org'
ruby '2.5.0'

gem 'rails', '5.1.4'
gem 'bcrypt'
gem 'faker'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'bootstrap-sass', '3.3.7'
gem 'puma'
gem 'sass-rails', '5.0.6'
gem 'uglifier', '3.0.0'
gem 'coffee-rails', '4.2.1'
gem 'jbuilder'
gem 'carrierwave', '0.11.2'
gem 'mini_magick', '4.5.1'
gem 'fog-aws'
gem 'active_model_serializers', '~> 0.10.0'
gem 'underscore-rails'
gem 'figaro'
gem 'file_validators'
gem 'tipsy-rails'
gem 'bootstrap-wysihtml5-rails'
gem 'devise'
gem 'omniauth'
gem 'bitfields', '0.7.0'
gem 'delayed_job_active_record'
gem 'carrierwave_backgrounder'
gem 'daemons'
gem 'font-awesome-rails'
gem 'nokogiri', '~> 1.8.1'
gem 'contact_us', '~> 1.0.1'
gem 'simple_form'
gem 'inline_svg'
gem 'loadcss-rails'

group :production do
  gem 'heroku-deflater', :group => :production, git: "https://github.com/romanbsd/heroku-deflater.git"
  gem 'pg', '~> 0.18'
end

group :development, :test do
  gem 'critical-path-css-rails'
  gem 'mysql2'
  gem 'pry'
  gem 'factory_bot'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'pry-byebug'
end

group :test do
  gem 'rails-controller-testing', '0.1.1'
  gem 'guard',                    '2.13.0'
  gem 'shoulda-matchers',         '~> 3.1'
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
