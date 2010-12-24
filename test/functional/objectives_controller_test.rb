require 'test_helper'

class ObjectivesControllerTest < ActionController::TestCase
  setup do
    @objective = objectives(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:objectives)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create objective" do
    assert_difference('Objective.count') do
      post :create, :objective => @objective.attributes
    end

    assert_redirected_to objective_path(assigns(:objective))
  end

  test "should show objective" do
    get :show, :id => @objective.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @objective.to_param
    assert_response :success
  end

  test "should update objective" do
    put :update, :id => @objective.to_param, :objective => @objective.attributes
    assert_redirected_to objective_path(assigns(:objective))
  end

  test "should destroy objective" do
    assert_difference('Objective.count', -1) do
      delete :destroy, :id => @objective.to_param
    end

    assert_redirected_to objectives_path
  end
end
