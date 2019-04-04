source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '~> 5.1.3'
gem 'rails', '~> 5.2.2'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
#gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
#gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem "listen"
gem 'ar-octopus'
gem "store_attribute", "~>0.5.0"
gem 'tzinfo-data' #, platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'i18n', '~> 0.9.3'
gem 'graphql' , '1.7.14'
gem 'graphql-batch'
gem 'graphql-preload'
gem 'graphql-errors'
gem 'apollo-tracing'
gem 'mysql2'
# gem "punching_bag"
gem 'shortener', git: 'https://github.com/jpmcgrath/shortener.git'
gem 'bootsnap', require: false
# gem "bitly"
# gem 'activerecord-jdbcmysql-adapter', git: "https://github.com/jruby/activerecord-jdbc-adapter/", tag: "v51.0", :platform => :jruby
gem 'awesome_nested_set', git: 'https://github.com/collectiveidea/awesome_nested_set.git'
gem 'rack-cors', :require => 'rack/cors'
gem 'sendgrid-ruby'
gem 'mime-types', require: 'mime/types'

gem 'devise'
gem 'devise-jwt'

gem 'globalize', git: 'https://github.com/globalize/globalize'
gem 'activemodel-serializers-xml'
gem 'active_delegate'
# gem 'ruby-prof'
# gem 'ruby-prof-flamegraph'

gem 'will_paginate'
gem "google_url_shortener", :require => 'google_url_shortener'
gem 'dotenv-rails', :groups => [:development, :test]
gem 'annotate', group: :development

group :development, :test do
  gem 'rspec-rails', '~> 3.8', group: :development
  gem 'devise-specs', group: :development
  gem "json_matchers", group: :test
  gem 'rspec-graphql_matchers', group: :test
  gem 'guard-rspec', require: false, group: :development
  gem 'growl'
  # gem 'growl_notify'
  gem "terminal-notifier"
  gem 'terminal-notifier-guard'
  gem 'fabrication'
end

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# group :development, :test do
#   # Call 'byebug' anywhere in the code to stop execution and get a debugger console
#   gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
#   # Adds support for Capybara system testing and selenium driver
#   gem 'capybara', '~> 2.13'
#   gem 'selenium-webdriver'
#   # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
#   gem 'web-console', '>= 3.3.0'
#   gem 'listen', '>= 3.0.5', '< 3.2'
#   # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
#   gem 'spring'
#   gem 'spring-watcher-listen', '~> 2.0.0'
# end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem

