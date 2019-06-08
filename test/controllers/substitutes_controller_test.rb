require 'test_helper'

class SubstitutesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get substitutes_index_url
    assert_response :success
  end

end
