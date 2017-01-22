class UsersController < ApplicationController
  before_action :ensure_user_logged_in, only: [:index, :edit, :update, :destroy]
  before_action :ensure_correct_user,   only: [:edit, :update]
  before_action :ensure_admin_user, only: :destroy

  def index
    @page_title = 'All users'
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @page_title = @user.name
  end

  def edit
    @user = User.find(params[:id])
    @page_title = 'Edit User'
  end

  def new
    @user = User.new
  end

  def create
    @page_title = 'Sign up'

    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def ensure_user_logged_in
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def ensure_admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
