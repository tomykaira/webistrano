require File.dirname(__FILE__) + '/../test_helper'

class NotificationTest < ActionMailer::TestCase
  tests Notification
  
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'

  test "sender_address" do
    Notification.webistrano_sender_address = "FooBar"
    
    stage = create_new_stage
    role = create_new_role(:stage => stage, :name => 'app')
    assert stage.deployment_possible?, stage.deployment_problems.inspect
    deployment = create_new_deployment(:stage => stage, :task => 'deploy')
    
    @expected.from = 'FooBar'
    @expected.to   = 'foo@bar.com'
    
    assert_equal @expected.encoded, Notification.deployment(deployment, 'foo@bar.com').encoded
  end

end
