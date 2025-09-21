class CreateImoniChains < ActiveRecord::Migration[8.0]
  def change
    create_table :imoni_chains do |t|
      t.text :base_ingredients
      t.string :new_ingredient
      t.integer :combo_rating
      t.string :creator_name
      t.integer :chaos_level
      t.text :special_message

      t.timestamps
    end
  end
end
