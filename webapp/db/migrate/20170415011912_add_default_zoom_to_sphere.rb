class AddDefaultZoomToSphere < ActiveRecord::Migration[5.0]
  def change
    add_column :spheres, :default_zoom, :integer, default: 50
  end
end
