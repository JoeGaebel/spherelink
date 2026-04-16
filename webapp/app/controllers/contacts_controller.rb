class ContactsController < ContactUs::ContactsController
  def new
    @page_title = "Feedback"
    @contact = ContactUs::Contact.new
    render_new_page
  end
end
