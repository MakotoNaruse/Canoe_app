require 'test_helper'

class UniversitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get login_form" do
    get univesities_login_form_url
    assert_response :success
  end

end
