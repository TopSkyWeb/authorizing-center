# AuthorizingCenter

the gem only for auth

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'authorizing_center',git: 'https://github.com/TopSkyWeb/authorizing-center'
```

And then execute:

    $ bundle

## Install

    $ rails generate authorizing_center:install
adjust /config/initializers/authorizing_center.rb

## Usage

- Authorize Ininder
```ruby
AuthorizingCenter::Ininder.authorize?(username, password)
```
- Authorize Uc 
```ruby
AuthorizingCenter::UcCenter.authorize?(username, password)
```
- Get User Information From account
```ruby
AuthorizingCenter::UcCenter.user_information(username)
```
