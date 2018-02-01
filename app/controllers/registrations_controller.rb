class RegistrationsController < Devise::RegistrationsController
  def new
    @page_title = "Sign up"
    super
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end