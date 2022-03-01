class CreateEcoles < ActiveRecord::Migration[6.1]
  def change
    create_table :ecoles do |t|
      t.string :type
      t.string :statut
      t.decimal :latitude
      t.decimal :longitude
      t.references :commune, null: false, foreign_key: true

      t.timestamps
    end
  end
end
