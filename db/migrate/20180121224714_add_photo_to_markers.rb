class AddPhotoToMarkers < ActiveRecord::Migration[5.1]
  def change
    add_column :markers, :guid, :string
    add_column :markers, :embedded_photo, :string
    add_column :markers, :embedded_photo_processing, :boolean, null: false, default: false

    add_index :markers, :guid
  end
end
