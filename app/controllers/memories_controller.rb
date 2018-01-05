class MemoriesController < ApplicationController
  before_action :ensure_allowed_access, only: [:show, :edit]
  before_action :authenticate_user!, only: [:index, :new, :edit, :create]

  def create
    @hideFlash = true
    @memory = current_user.memories.build(memory_params)

    if @memory.save
      sphere_params = params[:memory][:spheres_attributes]
      build_spheres(@memory, sphere_params) if sphere_params

      @memory.valid?

      if @memory.errors.present?
        @memory.destroy
        flash[:danger] = @memory.errors.full_messages.join(",")
        render :new
        return
      end

      flash[:success] = "Memory created! Now add the finishing touches"
      redirect_to edit_memory_path(@memory)
    else
      flash[:danger] = @memory.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
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

  def set_details
    memory = current_user.memories.find_by(id: params[:id])

    if memory.blank?
      render json: {}, status: :not_found
      return
    end

    memory.name = sanitize(params[:name]) if params[:name].present?
    memory.description = sanitize(params[:description]) if params[:description].present?
    memory.private = params[:private] if is_boolean?(params[:private])

    if memory.save
      render json: { name: memory.name, description: memory.description, private: memory.private }, status: :created
    else
      render json: memory.errors, status: :not_found
    end
  end

  private

  def ensure_allowed_access
    memory = Memory.find(params[:id])
    not_found if memory.blank?

    if memory.private
      if user_signed_in? && memory.user_id == current_user.id
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
    sphere_params.each do |_, sphere_attrs|
      sphere = memory.spheres.build
      sphere.panorama = sphere_attrs[:panorama]
      sphere.caption = sphere_attrs[:caption]
      sphere.save
    end
  end
end
