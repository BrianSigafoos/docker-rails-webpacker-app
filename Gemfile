# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1'
# Use postgresql as the database for Active Record
gem 'pg'

# Use Puma as the app server
gem 'puma'

# Frontend powered by Hotwire (Turbo + Stimulus) withTailwindCSS
# both Stimulus and Tailwind and dependencies in package.json
# gem 'hotwire-rails'
# hotwire-rails includes stimulus-rails for asset pipeline usage, we use webpacker
# instead so only using turbo-rails
gem 'turbo-rails'
gem 'view_component'
gem 'webpacker', '6.0.0.rc.6'

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

# Used in lint-job only and installed there.
# gem 'bundler-audit', require: false
# gem 'ruby_audit', require: false

# Brakeman usage: `brakeman -o brakeman_report.txt`
# For interactive brakeman that updates config/brakeman.ignore
# gem update brakeman # Get latest
# brakeman -I --skip-files /app/views/super/,/app/controllers/super/
# gem 'brakeman', require: false

# Needed during Ruby 3.1 upgrade, using Rails 6.1.5
# https://qiita.com/jnchito/items/4ef331281f0050428716#%E5%8E%9F%E5%9B%A0%E3%81%A8%E8%A7%A3%E6%B1%BA%E6%96%B9%E6%B3%95
# Ruby 3.1 release notes:
# https://www.ruby-lang.org/en/news/2021/12/25/ruby-3-1-0-released/
# gem 'debug'
# gem 'matrix'
# gem 'net-imap'
# gem 'net-pop'
# gem 'net-smtp'
# gem 'prime'

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

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen'
  gem 'spring'

  # Profiler for your development and production Ruby rack apps: https://github.com/MiniProfiler/rack-mini-profiler
  # gem 'rack-mini-profiler'

  # Flamegraph profiling support for Ruby 2.0 https://github.com/SamSaffron/flamegraph
  # gem 'flamegraph'

  # a sampling call-stack profiler for ruby 2.1+ https://github.com/tmm1/stackprof
  # gem 'stackprof' # ruby 2.1+ only

  # memory_profiler for ruby https://github.com/SamSaffron/memory_profiler
  # gem 'memory_profiler'
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
