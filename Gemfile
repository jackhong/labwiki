source "https://rubygems.org"

gem "i18n"
gem "omf_web", :git => 'git://github.com/mytestbed/omf_web'
gem "httparty"
gem "ruby_parser", "~> 2.3.1"

group :auth do
  gem "warden-openid"
end

group :db do
  gem "pg"
  gem "em-pg-client", "~> 0.2.1", :require => ['pg/em', 'em-synchrony/pg']
  gem "em-pg-sequel"
end

group :dev do
  gem "pry"
end
