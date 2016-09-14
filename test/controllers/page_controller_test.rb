require 'test_helper'

class PageControllerTest < ActionDispatch::IntegrationTest
  test "should get query" do
    get page_query_url
    assert_response :success
  end

  test "should get details" do
    get page_details_url
    assert_response :success
  end

  test "should get display" do
    get page_display_url
    assert_response :success
  end

end
