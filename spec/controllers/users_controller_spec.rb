require 'spec_helper'

describe UsersController do
  render_views

  it 'should get new' do
    get :new
    assert_response :success
  end
end
