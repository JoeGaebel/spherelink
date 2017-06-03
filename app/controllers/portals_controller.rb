class PortalsController < ApplicationController
  before_action :ensure_user_logged_in, only: [:create]

  def create
    parent_sphere = current_user.spheres.find(params[:id])
    to_sphere = current_user.spheres.find(params[:portal][:to_sphere_id])

    return render(error: :not_found) unless parent_sphere.present? && to_sphere.present?

    portal = parent_sphere.portals.build
    portal.polygon_px = params[:portal][:polygon_px]
    portal.to_sphere_id = to_sphere.id

    if portal.save
      render json: portal, status: :created
    else
      render json: portal.errors, status: :unprocessable_entity
    end
  end

  def portal_params
    params.require(:portal).permit(:polygon_px, :to_sphere_id)
  end

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
end
