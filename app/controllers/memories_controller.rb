class MemoriesController < ApplicationController
  before_action :ensure_allowed_access, only: [:show]
  before_action :ensure_user_logged_in, only: [:index]

  def show
  end

  def index
    @memories = current_user.memories
  end

  private

  def ensure_allowed_access
    memory = Memory.find(params[:id])
    not_found if memory.blank?
    set_instance_vars(memory) unless memory.private

    if memory.private
      if logged_in? && memory.user_id == current_user.id
        set_instance_vars(memory)
      else
        redirect_to_home
      end
    end
  end

  def redirect_to_home
    flash[:info] = "This memory is private, please log in."
    redirect_to root_path
  end

  def set_instance_vars(memory)
    @memory = memory
    @memory_json = memory.to_builder.target!
  end
end
