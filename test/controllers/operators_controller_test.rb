require 'test_helper'

class OperatorsControllerTest < ActionDispatch::IntegrationTest
  test "should get login_form" do
    get operators_login_form_url
    assert_response :success
  end

end
