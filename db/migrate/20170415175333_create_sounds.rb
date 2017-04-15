class CreateSounds < ActiveRecord::Migration[5.0]
  def change
    create_table :sounds do |t|
      t.integer :volume
      t.string :name
      t.string :file
      t.integer :loops
      t.timestamps
    end

    create_table :sound_contexts do |t|
      t.references :context, polymorphic: true
      t.references :sound
    end
  end
end
