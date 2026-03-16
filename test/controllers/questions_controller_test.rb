require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  test "step2 keeps the stored seasoning on revisit" do
    get questions_step2_path, params: { seasoning: "醤油" }
    assert_response :success

    get questions_step2_path
    assert_response :success
    assert_includes response.body, "鶏肉"
  end

  test "result redirects to the first step when seasoning is missing" do
    get questions_result_path, params: { feature: regions(:akita).feature }

    assert_redirected_to questions_step1_path
  end

  test "result can be refreshed without losing the selected region" do
    get questions_step2_path, params: { seasoning: "醤油" }
    assert_response :success

    get questions_step3_path, params: { meat: "鶏" }
    assert_response :success
    assert_includes response.body, regions(:akita).feature

    get questions_result_path, params: { feature: regions(:akita).feature }
    assert_response :success
    assert_includes response.body, "秋田"
    assert_includes response.body, "で芋煮ケーションする"

    get questions_result_path
    assert_response :success
    assert_includes response.body, "秋田"
  end
end