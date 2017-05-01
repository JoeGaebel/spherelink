class MemoriesController < ApplicationController
  before_action :ensure_allowed_access, only: [:show]
  before_action :ensure_user_logged_in, only: [:index, :new, :create]

  def create
    binding.pry
    @memory = current_user.memories.build(memory_params)
    if booleanify(params[:next])
      if @memory.save
        redirect_to new_sphere_path(id: @memory.id)
      else
        flash[:danger] = "Error!"
        render :new
      end
    else
      if @memory.save
        redirect_to memories_path
      end
    end
  end

  def new
    @memory = current_user.memories.build
  end

  def show
  end

  def index
    @memories = current_user.memories
  end

  def destroy
    memory = current_user.memories.find_by(id: params[:id])
    memory.destroy if memory
    redirect_to memories_path
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

  def memory_params
    params.require(:memory).permit(:name, :description, :private)
  end
end
