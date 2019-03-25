require 'test_helper'

class RanksControllerTest < ActionDispatch::IntegrationTest
  test "should get add" do
    get ranks_add_url
    assert_response :success
  end

end
