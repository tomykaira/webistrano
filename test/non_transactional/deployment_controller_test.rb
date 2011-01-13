require File.dirname(__FILE__) + '/../non_transactional_test_helper'
require 'deployments_controller'

# Re-raise errors caught by the controller.
class DeploymentsController; def rescue_action(e) raise e end; end

class DeploymentsControllerTest < Test::Unit::TestCase
  def setup
    Project.destroy_all
    @controller = DeploymentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @project = Factory(:project, :name => 'Project X')
    @stage = Factory(:stage, :name => 'Prod', :project => @project)
    @role = Factory(:role, :name => 'web', :stage => @stage)
    @deployment = Factory(:deployment, :task => 'deploy:setup', :stage => @stage)
    
    @user = login
  end

  test "locking_checked" do
    @stage.lock
    assert_no_difference "Deployment.count" do
      post :create, :deployment => { :task => 'deploy:default', :description => 'update to newest' }, :project_id => @project.id, :stage_id => @stage.id
    end

    assert_response :success
  end
  
  test "locking_override" do
    @stage.lock
    assert_difference "Deployment.count" do
      post :create, :deployment => { :task => 'deploy:default', :description => 'update to newest', :override_locking => 1 }, :project_id => @project.id, :stage_id => @stage.id
    end

    assert_response :redirect
  end
  
  test "stage_locked_after_deploy" do
    assert !@stage.locked?
    assert_difference "Deployment.count" do
      post :create, :deployment => { :task => 'deploy:default', :description => 'update to newest' }, :project_id => @project.id, :stage_id => @stage.id
    end

    assert_response :redirect
    assert @stage.reload.locked?
  end
    
end


