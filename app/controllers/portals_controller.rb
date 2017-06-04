class PortalsController < ApplicationController
  before_action :ensure_user_logged_in, only: [:create]

  def create
    parent_sphere = current_user.spheres.find(params[:id])
    to_sphere = current_user.spheres.find(params[:portal][:to_sphere_id])

    if parent_sphere.blank? || to_sphere.blank?
      render json: { status: :not_found }
      return
    end

    portal = parent_sphere.portals.build
    portal.polygon_px = params[:portal][:polygon_px]
    portal.tooltip_content = params[:portal][:content]
    portal.to_sphere_id = to_sphere.id

    if portal.save
      render json: portal, status: :created
    else
      render json: portal.errors, status: :not_found
    end
  end

  def destroy
    parent_sphere = current_user.spheres.find(params[:sphere_id])

    if parent_sphere.blank?
      render json: { status: :not_found }
      return
    end

    portal = parent_sphere.portals.find(params[:id])
    if portal.present? && portal.destroy
      render json: portal, status: :ok
    else
      render json: portal.errors, status: :not_found
    end
  end

end
