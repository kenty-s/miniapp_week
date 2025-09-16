class CreateRegions < ActiveRecord::Migration[8.0]
  def change
    create_table :regions do |t|
      t.string :name
      t.string :meat
      t.string :seasoning
      t.text :feature

      t.timestamps
    end
  end
end
