class SpheresController < ApplicationController
  before_action :get_memory, only: [:create, :new]

  def create
    binding.pry
    @memory = current_user.memories.find_by(id: params[:sphere][:memory_id])
    @sphere = @memory.spheres.create(sphere_params)
    if @sphere.save
      flash[:success] = "Sphere created!"
      redirect_to memories_path
    else
      flash[:error] = "no bueno"
      render :new
    end
  end

  def new
    @sphere = @memory.spheres.build
  end

  def get_memory
    @memory = current_user.memories.find_by(id: params[:id])
  end

  def sphere_params
    params.require(:sphere).permit(:panorama)
  end
end
