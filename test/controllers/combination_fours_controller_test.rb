require 'test_helper'

class CombinationFoursControllerTest < ActionDispatch::IntegrationTest
  test "should get add" do
    get combination_fours_add_url
    assert_response :success
  end

end
