# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1'
# Use postgresql as the database for Active Record
gem 'pg'

# Frontend powered by Hotwire (Turbo + Stimulus) withTailwindCSS
# both Stimulus and Tailwind and dependencies in package.json
# gem 'hotwire-rails'
# hotwire-rails includes stimulus-rails for asset pipeline usage, we use webpacker
# instead so only using turbo-rails
gem 'turbo-rails'
gem 'view_component', require: 'view_component/engine'
gem 'webpacker', '6.0.0.rc.6'

# Use Puma as the app server
gem 'puma'

gem 'sidekiq'
gem 'sidekiq_alive'
gem 'sidekiq-cron'

# Use SCSS for stylesheets
# gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :development, :test do
  gem 'better_html'
  gem 'bullet'
  gem 'erb_lint', require: false
  gem 'pry'
  gem 'rubocop',               require: false
  gem 'rubocop-minitest',      require: false
  gem 'rubocop-performance',   require: false
  gem 'rubocop-rails',         require: false
  gem 'rubocop-rake',          require: false
  gem 'rubocop-thread_safety', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
