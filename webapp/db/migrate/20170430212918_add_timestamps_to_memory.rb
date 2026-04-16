class AddTimestampsToMemory < ActiveRecord::Migration[5.0]
  def change
    add_column(:memories, :created_at, :datetime)
    add_column(:memories, :updated_at, :datetime)
  end
end
