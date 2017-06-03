class MemoriesController < ApplicationController
  before_action :ensure_allowed_access, only: [:show, :link]
  before_action :ensure_user_logged_in, only: [:index, :new, :link, :create]

  def create
    @memory = current_user.memories.build(memory_params)

    if @memory.save
      sphere_params = params[:memory][:spheres_attributes]
      errors = build_spheres(@memory, sphere_params) if sphere_params

      if errors.present?
        flash[:danger] = errors.map(&:full_messages).uniq.join(",")
        render :new
        return
      end

      flash[:success] = "Memory created!"
      redirect_to memories_path
    else
      flash[:danger] = @memory.errors.full_messages.join(", ")
      render :new
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

  def link
  end

  private

  def ensure_allowed_access
    memory = Memory.find(params[:id])
    not_found if memory.blank?

    if memory.private
      if logged_in? && memory.user_id == current_user.id
        set_instance_vars(memory)
      else
        redirect_to_home
      end
    else
      set_instance_vars(memory)
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

  def build_spheres(memory, sphere_params)
    errors = []

    sphere_params.each do |_, sphere_attrs|
      return unless sphere_attrs[:panorama]

      sphere = memory.spheres.build
      sphere.panorama = sphere_attrs[:panorama]
      sphere.caption = sphere_attrs[:caption]

      unless sphere.save
        errors << sphere.errors
      end
    end

    errors
  end
end
