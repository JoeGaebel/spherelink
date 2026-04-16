class UpdateSphereCarrierwaveAttrs < ActiveRecord::Migration[5.0]
  def change
    add_column :spheres, :panorama_processing, :boolean, null: false, default: false
    add_column :spheres, :panorama_tmp, :string
    remove_column :spheres, :processing_bits
  end
end
