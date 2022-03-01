class CreateCommunes < ActiveRecord::Migration[6.1]
  def change
    create_table :communes do |t|
      t.string :name
      t.integer :zipcod
      t.integer :zipinsee
      t.float :price

      t.timestamps
    end
  end
end
