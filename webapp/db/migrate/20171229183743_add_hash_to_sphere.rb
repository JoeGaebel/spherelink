class AddHashToSphere < ActiveRecord::Migration[5.0]
  def change
    add_column :spheres, :guid, :string
    add_column :spheres, :processing_bits, :integer, default: 0, null: false

    add_index :spheres, :guid
  end
end