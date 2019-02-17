require 'test_helper'

class OperationsControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get operations_top_url
    assert_response :success
  end

end
