require 'test_helper'

class ResultsControllerTest < ActionDispatch::IntegrationTest
  test "should get add" do
    get results_add_url
    assert_response :success
  end

end
