class AddLatAndLongToPortal < ActiveRecord::Migration[5.0]
  def change
    add_column :portals, :fov_lat, :decimal, precision: 18, scale: 17, default: 0
    add_column :portals, :fov_lng, :decimal, precision: 18, scale: 17, default: 0
  end
end
