class ModifieTypeToFloat < ActiveRecord::Migration[6.1]
  def change
    change_column :communes, :latitude, :float
    change_column :communes, :longitude, :float
    change_column :ecoles, :latitude, :float
    change_column :ecoles, :longitude, :float
    change_column :gares, :latitude, :float
    change_column :gares, :longitude, :float
    change_column :pharmacies, :lattitude, :float
    change_column :pharmacies, :longitude, :float
  end
end
