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
gem 'acts-as-taggable-on', :version => '~> 1.1.5'
gem 'paperclip',           :version => '~> 2.3.1'
gem 'aasm',                :version => '~> 2.1.5'
gem 'gchartrb',            :lib => 'google_chart'
gem 'vpim',                :lib => 'vpim/icalendar'
gem 'RedCloth'
gem 'color'
gem 'hpricot'
gem 'fastercsv'
gem 'comma', '~> 0.3.2'

group :borked do
  # rwikibot and deep_merge hose the routes so they're left out for now
  gem 'deep_merge'
  gem 'rwikibot', '= 2.0.7', :path => 'vendor/gems/rwikibot-2.0.7'
end

group :development do
  gem 'ruby-debug',     :lib => false
  gem 'capistrano',     :lib => false
  gem 'capistrano-ext', :lib => false
end

group :test do
  gem 'rcov',             '~> 0.9.7', :lib => false
  gem 'rspec',            '~> 1.3.0', :lib => false
  gem 'rspec-rails',      '~> 1.3.0', :lib => false
  gem 'cucumber',         '~> 0.6.2', :lib => false
  gem 'cucumber-rails',   '~> 0.2.4', :lib => false
  gem 'webrat',           '~> 0.7.0', :lib => false
  gem 'database_cleaner', '~> 0.4.3', :lib => false
end
