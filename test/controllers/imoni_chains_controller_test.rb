require "test_helper"

class ImoniChainsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get imoni_chains_index_url
    assert_response :success
  end

  test "should get show" do
    get imoni_chains_show_url
    assert_response :success
  end

  test "should get new" do
    get imoni_chains_new_url
    assert_response :success
  end

  test "should get create" do
    get imoni_chains_create_url
    assert_response :success
  end
end
