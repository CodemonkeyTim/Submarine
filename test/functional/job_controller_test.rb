require 'test_helper'

class JobControllerTest < ActionController::TestCase
  test "should get job" do
    get :job
    assert_response :success
  end

end
