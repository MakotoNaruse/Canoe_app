require 'test_helper'

class RemarksControllerTest < ActionDispatch::IntegrationTest
  test "should get add" do
    get remarks_add_url
    assert_response :success
  end

end
