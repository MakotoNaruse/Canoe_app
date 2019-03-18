require 'test_helper'

class BibsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bibs_index_url
    assert_response :success
  end

end
