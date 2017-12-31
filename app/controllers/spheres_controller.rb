class SpheresController < ApplicationController
  before_action :ensure_user_logged_in

  rescue_from(ActionController::ParameterMissing) do |exception|
    error = {}
    error[exception.param] = ['parameter is required']

    render json: { errors: [error] }, status: :unprocessable_entity
  end

  def create
    memory = current_user.memories.find_by(id: params[:memory_id])

    if memory.blank?
      render json: {}, status: :not_found
      return
    end

    sphere = memory.spheres.build
    sphere.caption = create_params[:caption]
    sphere.panorama = create_params[:panorama]
    sphere.processing_bits = Sphere::MAX_PROCESSING_BIT

    guid = SecureRandom.hex
    sphere.guid = guid

    if sphere.valid?
      render json: guid, status: :accepted
      sphere.save!
    else
      render json: sphere.errors, status: :unprocessable_entity
    end
  end

  def show
    sphere = current_user.spheres.find_by(guid: params[:id])

    if sphere.blank?
      render json: {}, status: :not_found
      return
    end

    if sphere.processing?
      render json: sphere.guid, status: :accepted
      return
    end

    render json: sphere.to_builder.target!, status: :created
  end

  def destroy
    sphere = current_user.spheres.find(params[:id])

    if sphere.memory.spheres.count == 1
      render json: {}, status: :forbidden
      return
    end

    if sphere.blank?
      render json: {}, status: :not_found
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
      render json: {}, status: :not_found
      return
    end

    sphere.default_zoom = params[:default_zoom]

    if sphere.save
      render json: sphere.to_builder.target!, status: :created
    else
      render json: sphere.errors, status: :not_found
    end
  end

  private

  def create_params
    params.require(:sphere).permit(:caption, :panorama)
  end
end
