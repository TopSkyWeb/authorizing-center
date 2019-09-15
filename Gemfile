source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in authorizing_center.gemspec
gemspec
gem "rails", "~> 5.2"

group :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'webmock'
  gem 'faker'
end