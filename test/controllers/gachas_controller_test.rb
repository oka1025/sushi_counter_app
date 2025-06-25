require "test_helper"

class GachasControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get gachas_show_url
    assert_response :success
  end

  test "should get draw" do
    get gachas_draw_url
    assert_response :success
  end
end
