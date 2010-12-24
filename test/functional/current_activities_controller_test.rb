require 'test_helper'

class CurrentActivitiesControllerTest < ActionController::TestCase
  setup do
    @current_activity = current_activities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:current_activities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create current_activity" do
    assert_difference('CurrentActivity.count') do
      post :create, :current_activity => @current_activity.attributes
    end

    assert_redirected_to current_activity_path(assigns(:current_activity))
  end

  test "should show current_activity" do
    get :show, :id => @current_activity.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @current_activity.to_param
    assert_response :success
  end

  test "should update current_activity" do
    put :update, :id => @current_activity.to_param, :current_activity => @current_activity.attributes
    assert_redirected_to current_activity_path(assigns(:current_activity))
  end

  test "should destroy current_activity" do
    assert_difference('CurrentActivity.count', -1) do
      delete :destroy, :id => @current_activity.to_param
    end

    assert_redirected_to current_activities_path
  end
end
