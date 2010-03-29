# Additional libraries are loaded in "config/initializers/libraries.rb".

# Repository:
source :gemcutter

# Rails version, which must be specified here AND in the environment.rb:
gem "rails", "~> 2.3.5", :require => nil

# Selectively-loaded:
gem 'sqlite3-ruby', :lib => false # For default database driver
gem 'mysql',        :lib => false # For commonly used database driver
gem 'rack-openid',  :lib => false # For open_id_authentication
gem 'right_aws',    :lib => false # For paperclip
gem 'facets',       :lib => false # For config/initializers/libraries.rb

# Necessary:
gem 'acts-as-taggable-on', '~> 1.1.5'
gem 'paperclip', '~> 2.3.1'
gem 'aasm', '~> 2.1.5'
gem 'gchartrb'
gem 'vpim'
gem 'RedCloth'
gem 'color'
gem 'hpricot'
gem 'fastercsv'
gem 'comma', '~> 0.3.2'

group :borked do
  # rwikibot and deep_merge hose the routes so they're left out for now
  gem 'rwikibot', '= 2.0.7', :path => 'vendor/gems/rwikibot-2.0.7'
  gem 'deep_merge'
end

group :development do
  gem 'ruby-debug'
  gem 'capistrano'
  gem 'capistrano-ext'
end

group :test do
  gem 'rcov',             '~> 0.9.7'
  gem 'rspec',            '~> 1.3.0'
  gem 'rspec-rails',      '~> 1.3.0'
  gem 'cucumber',         '~> 0.6.2'
  gem 'cucumber-rails',   '~> 0.2.4'
  gem 'webrat',           '~> 0.7.0'
  gem 'database_cleaner', '~> 0.4.3'
end
