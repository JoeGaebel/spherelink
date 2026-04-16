ContactUs.setup do |config|
  config.mailer_from = "noreply@spherelink.io"
  config.mailer_to = "contact.spherelink@gmail.com"
  config.require_name = false
  config.require_subject = true
  config.form_gem = 'simple_form'
  config.success_redirect = '/contact-success'
end
