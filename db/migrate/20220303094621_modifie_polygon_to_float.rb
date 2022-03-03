class ModifiePolygonToFloat < ActiveRecord::Migration[6.1]
  def change
    remove_column :communes, :polygon
    add_column :communes, :polygon, :float, array: true, default: []
  end
end
