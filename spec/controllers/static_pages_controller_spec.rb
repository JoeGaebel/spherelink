require 'spec_helper'

describe StaticPagesController do
  render_views
  let(:pages) { [:home, :help, :about]}

  it 'should get the pages' do
    pages.each do |page|
      get page
      assert_response :success
      expect(response.body).to match "<title>#{page.to_s.capitalize} | Social MicroLoan</title>"
    end
  end
end
