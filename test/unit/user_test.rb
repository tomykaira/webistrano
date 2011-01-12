require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  fixtures :users

  test "should_create_user" do
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
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
    user.remember_me!

    assert_equal false, user.remember_expired?

    user.disable
    user.reload

    assert user.remember_created_at.blank?
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
      User.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire!', :password_confirmation => 'quire!' }.merge(options))
    end
end
