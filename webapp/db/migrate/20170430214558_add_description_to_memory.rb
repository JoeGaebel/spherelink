class AddDescriptionToMemory < ActiveRecord::Migration[5.0]
  def change
    add_column(:memories, :description, :text)
  end
end
