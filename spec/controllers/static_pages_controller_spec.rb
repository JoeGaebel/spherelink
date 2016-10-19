require 'spec_helper'

describe StaticPagesController do
  it 'should get home' do
    get static_pages_home_url
    assert_response :success
  end
end