class CreateGares < ActiveRecord::Migration[6.1]
  def change
    create_table :gares do |t|
      t.decimal :latitude
      t.decimal :longitude
      t.references :commune, null: false, foreign_key: true

      t.timestamps
    end
  end
end
