require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users

  test "should_create_user" do
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  test "should_require_login" do
    assert_no_difference 'User.count' do
      u = create_user(:login => nil)
      assert !u.errors[:login].empty?
    end
  end

  test "should_require_password" do
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert !u.errors[:password].empty?
    end
  end

  test "should_require_password_confirmation" do
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert !u.errors[:password_confirmation].empty?
    end
  end

  test "should_require_email" do
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert !u.errors[:email].empty?
    end
  end
  
  test "should_not_authenticate_if_disabled" do
    assert_equal users(:quentin), User.authenticate('quentin', 'test')
    User.find_by_login("quentin").disable
    assert_equal nil, User.authenticate('quentin', 'test')
  end

  test "should_reset_password" do
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin', 'new password')
  end

  test "should_not_rehash_password" do
    users(:quentin).update_attributes(:login => 'quentin2')
    assert_equal users(:quentin), User.authenticate('quentin2', 'test')
  end

  test "should_authenticate_user" do
    assert_equal users(:quentin), User.authenticate('quentin', 'test')
  end

  test "should_set_remember_token" do
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  test "should_unset_remember_token" do
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end

  test "should_remember_me_for_one_week" do
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  test "should_remember_me_until_one_week" do
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert_equal users(:quentin).remember_token_expires_at, time
  end

  test "should_remember_me_default_two_weeks" do
    before = 2.weeks.from_now.utc
    users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end
  
  test "admin" do
    user = create_new_user
    assert !user.admin?
    
    user.admin = 1
    assert user.admin?
    
    user.revoke_admin!
    assert !user.admin?
    
    user.make_admin!
    assert user.admin?
  end
  
  test "revert_admin_status_only_if_other_admins_left" do
    User.delete_all
    
    admin = create_new_user
    admin.make_admin!
    assert admin.admin?
    
    user = create_new_user
    assert !user.admin?
    
    # check that the admin status of admin cannot be taken
    assert_raise(ActiveRecord::RecordInvalid){
      admin.revoke_admin!
    }
  end
  
  test "recent_deployments" do
    user = create_new_user
    stage = create_new_stage
    role = create_new_role(:stage => stage)
    5.times do 
      deployment = create_new_deployment(:stage => stage, :user => user)
    end
    
    assert_equal 5, user.deployments.count
    assert_equal 3, user.recent_deployments.size
    assert_equal 2, user.recent_deployments(2).size
  end
  
  test "disable" do
    user = create_new_user
    assert !user.disabled?
    
    user.disable
    
    assert user.disabled?
    
    user.enable
    
    assert !user.disabled?
  end
  
  test "disable_resets_remember_me" do
    user = create_new_user
    user.remember_me
    
    assert_not_nil user.remember_token
    assert_not_nil user.remember_token_expires_at
    
    user.disable
    
    assert_nil user.remember_token
    assert_nil user.remember_token_expires_at
  end
  
  test "enabled_named_scope" do
    User.destroy_all
    assert_equal [], User.enabled
    assert_equal [], User.disabled
    
    user = create_new_user
    
    assert_equal [user], User.enabled
    assert_equal [], User.disabled
    
    user.disable
    
    assert_equal [], User.enabled
    assert_equal [user], User.disabled
  end

  protected
    def create_user(options = {})
      User.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
end
