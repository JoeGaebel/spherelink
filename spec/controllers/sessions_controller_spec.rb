require 'spec_helper'

describe SessionsController do
  it 'should get new' do
    get :new
    assert_response :success
  end

  context 'with invalid information' do
    it 'shows an error message' do
      get :new
      assert_template 'sessions/new'
      post :create, params: { session: { email: '', password: '' } }
      assert_template 'sessions/new'
      assert !flash.empty?
      get :new
      assert flash.empty?
    end
  end
end
