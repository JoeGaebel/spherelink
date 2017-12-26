class PortalsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    parent_sphere = current_user.spheres.find(params[:id])
    to_sphere = current_user.spheres.find(params[:portal][:to_sphere_id])

    if parent_sphere.blank? || to_sphere.blank?
      render json: {}, status: :bad_request
      return
    end

    portal = parent_sphere.portals.build
    portal.polygon_px = params[:portal][:polygon_px]
    portal.tooltip_content = params[:portal][:content]
    portal.to_sphere_id = to_sphere.id

    if portal.save
      render json: portal.to_builder.target!, status: :created
    else
      render json: portal.errors, status: :bad_request
    end
  end

  def destroy
    parent_sphere = current_user.spheres.find(params[:sphere_id])

    if parent_sphere.blank?
      render json: {}, status: :bad_request
      return
    end

    portal = parent_sphere.portals.find(params[:id])
    if portal.present? && portal.destroy
      render json: portal.to_builder.target!, status: :ok
    else
      render json: portal.errors, status: :bad_request
    end
  end
end
