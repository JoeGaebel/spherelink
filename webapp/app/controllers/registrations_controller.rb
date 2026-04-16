class RegistrationsController < Devise::RegistrationsController
  def new
    @page_title = "Sign up"
    super
  end

  def create
    #Verify captcha
    if verify_recaptcha
      super
    else
      build_resource
      clean_up_passwords(resource)
      flash.now[:alert] = "There was an error with the recaptcha code below. Please re-enter the code."
      render :new
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end