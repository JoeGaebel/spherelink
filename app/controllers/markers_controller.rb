class MarkersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    parent_sphere = current_user.spheres.find_by(id: params[:id])

    if parent_sphere.blank?
      render json: {}, status: :bad_request
      return
    end

    marker = parent_sphere.markers.build
    marker.x = params[:marker][:x]
    marker.y = params[:marker][:y]
    marker.tooltip_content = params[:marker][:caption]
    marker.content = params[:marker][:content]
    marker.image = 'pin2.png'
    marker.width = Marker::DEFAULT_DIM
    marker.height = Marker::DEFAULT_DIM


    if marker.save
      render json: marker.to_builder.target!, status: :created
    else
      render_model_errors(marker)
    end
  end

  def destroy
    parent_sphere = current_user.spheres.find_by(id: params[:sphere_id])

    if parent_sphere.blank?
      render_not_found
      return
    end

    marker = parent_sphere.markers.find_by(id: params[:id])

    if marker.present?
      if marker.destroy
        render json: marker.to_builder.target!, status: :ok
      else
        render_model_errors(marker)
      end
    else
      render_not_found
    end
  end
end
