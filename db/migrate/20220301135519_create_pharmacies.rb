class CreatePharmacies < ActiveRecord::Migration[6.1]
  def change
    create_table :pharmacies do |t|
      t.string :name
      t.string :address
      t.integer :zip_code
      t.decimal :lattitude
      t.decimal :longitude
      t.references :commune, null: false, foreign_key: true

      t.timestamps
    end
  end
end
