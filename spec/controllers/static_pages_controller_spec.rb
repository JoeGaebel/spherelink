require 'spec_helper'

describe StaticPagesController do
  render_views
  let(:pages) { [:help, :about, :contact]}

  def assert_page_title(page, title)
    get page
    assert_response :success
    expect(response.body).to match title
  end

  it 'has the correct title for home' do
    assert_page_title(:home, '<title>Social Microloan</title>')
  end

  it 'should get the pages' do
    pages.each do |page|
      assert_page_title(page, "<title>#{page.to_s.capitalize} | Social MicroLoan</title>")
    end
  end

  context 'layout links' do
    it 'renders the correct links' do
      get :home
      assert_template 'static_pages/home'
      assert_select "a[href=?]", root_path, count: 2
      assert_select "a[href=?]", help_path
      assert_select "a[href=?]", about_path
      assert_select "a[href=?]", contact_path
    end
  end
end
