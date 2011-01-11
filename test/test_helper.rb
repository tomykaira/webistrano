ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require File.expand_path(File.dirname(__FILE__) + "/factories")
require 'authenticated_test_helper'


class ActiveSupport::TestCase
  
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  # 
  include AuthenticatedTestHelper
  include Factories

  # Add more helper methods to be used by all tests here...
  
  def prepare_email
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    return ActionMailer::Base.deliveries
  end
  
  def login(user=nil)
    user = user || create_new_user
    @request.session[:user] = user.id
    return user
  end
  
  def admin_login
    admin = login
    admin.make_admin!
    return admin
  end
  
  def assert_include(expected, value)
    assert_kind_of Array, value
    assert value.include?(expected)
  end
  
  def assert_empty(value)
    assert_kind_of Array, value
    assert value.empty?
  end
  
  def assert_not_empty(value)
    assert_kind_of Array, value
    assert !value.empty?
  end
end
