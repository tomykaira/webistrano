require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase

  fixtures :users

  def setup
    @controller = SessionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  test "should_login_and_redirect" do
    post :create, :login => 'quentin', :password => 'test'
    assert session[:user]
    assert_response :redirect
  end

  test "should_not_login_if_disabled" do
    User.find_by_login('quentin').disable

    post :create, :login => 'quentin', :password => 'test'
    assert_nil session[:user]
    assert_response :success
  end

  test "should_fail_login_and_not_redirect" do
    post :create, :login => 'quentin', :password => 'bad password'
    assert_nil session[:user]
    assert_response :success
  end

  test "should_logout" do
    login_as :quentin
    get :destroy
    assert_nil session[:user]
    assert_response :redirect
  end

  test "should_remember_me" do
    post :create, :login => 'quentin', :password => 'test', :remember_me => "1"
    assert_not_nil @response.cookies["auth_token"]
  end

  test "should_not_remember_me" do
    post :create, :login => 'quentin', :password => 'test', :remember_me => "0"
    assert_nil @response.cookies["auth_token"]
  end

  test "should_delete_token_on_logout" do
    login_as :quentin
    get :destroy
    assert_nil @response.cookies["auth_token"]
  end

  test "should_login_with_cookie" do
    users(:quentin).remember_me
    @request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    assert @controller.send(:user_signed_in?)
  end

  test "should_fail_expired_cookie_login" do
    users(:quentin).remember_me
    users(:quentin).update_attribute :remember_token_expires_at, 1.day.ago
    @request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    assert !@controller.send(:user_signed_in?)
  end

  test "should_fail_cookie_login" do
    users(:quentin).remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    assert !@controller.send(:user_signed_in?)
  end

  test "should_render_the_version_xml" do
    login_as :quentin
    get :version, :format => 'xml'
    assert_select "application" do |element|
      assert_select 'name', :text => "Webistrano"
      assert_select 'version', :text => WEBISTRANO_VERSION
    end
  end

  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end

    def cookie_for(user)
      auth_token users(user).remember_token
    end
end
