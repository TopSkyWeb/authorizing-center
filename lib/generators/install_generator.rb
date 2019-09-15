# frozen_string_literal: true

require 'rails/generators/base'

module AuthorizingCenter
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      def copy_initializer
        template "authorizing_center.rb", "config/initializers/authorizing_center.rb"
      end
    end
  end
end