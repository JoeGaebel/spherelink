require 'spec_helper'

describe StaticPagesController do
  let(:pages) { [:home, :help]}

  it 'should get the pages' do
    pages.each do |page|
      get page
      assert_response :success
    end
  end
end