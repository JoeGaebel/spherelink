class CreateMemoryModels < ActiveRecord::Migration[5.0]
  def change
    create_table :portals do |t|
      t.text :polygon_px
      t.string :fill, default: 'points'
      t.string :stroke, default: '#ff0032'
      t.integer :stroke_transparency, default: 80
      t.integer :stroke_width, default: 2
      t.string :tooltip_content
      t.string :tooltip_position, default: 'right bottom'

      t.integer :from_sphere_id
      t.integer :to_sphere_id
      t.timestamps
    end

    create_table :spheres do |t|
      t.string :panorama
      t.string :caption

      t.belongs_to :memory, index: true
      t.timestamps
    end

    create_table :markers do |t|
      t.string :image
      t.string :tooltip_content
      t.string :tooltip_position, default: 'right bottom'
      t.text :content
      t.integer :x
      t.integer :y
      t.integer :width
      t.integer :height

      t.belongs_to :sphere, index: true
      t.timestamps
    end

    create_table :memories do |t|
      t.string :name
      t.belongs_to :user
    end
  end
end
