class SpheresController < ApplicationController
  before_action :ensure_user_logged_in

  def create
    memory = current_user.memories.find(params[:memory_id])

    if memory.blank?
      render json: { status: :not_found }
      return
    end

    sphere = memory.spheres.build
    sphere.caption = params[:sphere][:caption]
    sphere.panorama = params[:sphere][:panorama]

    if sphere.save
      render json: sphere.to_builder.target!, status: :created
    else
      render json: sphere.errors, status: :not_found
    end
  end

  def destroy
    sphere = current_user.spheres.find(params[:id])

    if sphere.memory.spheres.count == 1
      render json: { status: :forbidden }
      return
    end

    if sphere.blank?
      render json: { status: :not_found }
      return
    end

    if sphere.destroy
      render json: sphere.to_builder.target!, status: :ok
    else
      render json: sphere.errors, status: :not_found
    end
  end

  def zoom
    sphere = current_user.spheres.find(params[:id])

    if sphere.blank?
      render json: { status: :not_found }
      return
    end

    sphere.default_zoom = params[:default_zoom]

    if sphere.save
      render json: sphere.to_builder.target!, status: :created
    else
      render json: sphere.errors, status: :not_found
    end
  end
end
