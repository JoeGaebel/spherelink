class AddPrivateToMemories < ActiveRecord::Migration[5.0]
  def change
    add_column(:memories, :private, :boolean, default: false)
  end
end
