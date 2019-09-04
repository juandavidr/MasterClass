source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'
gem 'bootstrap-sass', '2.3.2.0'

 gem 'sqlite3', '1.3.8'
# Use sqlite3 as the database for Active Record
group :development do
 
  gem 'rspec-rails', '2.13.1'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use bcrypt for password encryption
gem 'bcrypt-ruby', '~> 3.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'prime-rails' , '0.0.16'
#graficas!
gem 'lazy_high_charts'
#servicios rest
gem 'httparty'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

#Populate de DB with fake data
gem 'faker', '1.1.2'

#Pagination gems
gem 'will_paginate', '3.0.5'
gem 'bootstrap-will_paginate', '0.0.9'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# use Ruby debugger julian added
gem 'debugger', group: [:development, :test]

#Cucumber y Capybara
group :test, :development do
  gem 'cucumber-rails-training-wheels'#Es una gem de ejemplos
  gem 'database_cleaner' #Limpia la base de datos entre pruebas
  gem 'capybara' #web browser tester
  gem 'launchy' #debug de las user stories
  gem 'factory_girl_rails', '4.2.1'
end

group :test do
    gem 'cucumber-rails', :require => false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]


group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
  gem 'bcrypt-ruby', '~> 3.0.0'
end