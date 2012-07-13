require 'capistrano'

module Capistrano::Configuration::Actions::Inspect
  alias_method :webistrano_capture, :capture
end
