require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Webistrano
  class Application < Rails::Application


    # Make Active Record use UTC-base instead of local time
    config.time_zone = 'UTC'
    config.encoding = "utf-8"
    # config.filter_parameters += [:password, :password_confirmation]

    initializer "webistrano.load" do
      require 'webistrano'
    end

    initializer "webistrano.configure" do
      require "#{Rails.root}/config/webistrano_config"
      config.secret_token = WebistranoConfig[:session_secret]
    end

    initializer "webistrano.clean_stylsheet" do
      stylesheet = "#{Rails.root}/public/stylesheets/application.css"
      File.delete(stylesheet) if  File.exists?(stylesheet)
    end

  end
end


# TODO - is this needed? -- fd
require 'open4'
require 'capistrano/cli'
require 'syntax/convertors/html'


# set default time_zone to UTC
# TODO - is this needed? -- fd
ENV['TZ'] = 'UTC'
Time.zone = 'UTC'