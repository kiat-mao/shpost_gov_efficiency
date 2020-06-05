require 'test_helper'

class ExpressesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @express = expresses(:one)
  end

  test "should get index" do
    get expresses_url
    assert_response :success
  end

  test "should get new" do
    get new_express_url
    assert_response :success
  end

  test "should create express" do
    assert_difference('Express.count') do
      post expresses_url, params: { express: {  } }
    end

    assert_redirected_to express_url(Express.last)
  end

  test "should show express" do
    get express_url(@express)
    assert_response :success
  end

  test "should get edit" do
    get edit_express_url(@express)
    assert_response :success
  end

  test "should update express" do
    patch express_url(@express), params: { express: {  } }
    assert_redirected_to express_url(@express)
  end

  test "should destroy express" do
    assert_difference('Express.count', -1) do
      delete express_url(@express)
    end

    assert_redirected_to expresses_url
  end
end
