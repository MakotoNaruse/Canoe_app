require 'test_helper'

class FoursControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get fours_index_url
    assert_response :success
  end

end
