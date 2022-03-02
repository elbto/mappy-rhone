class AddPolygonToCommune < ActiveRecord::Migration[6.1]
  def change
    add_column :communes, :polygon, :string, array: true, default: []
  end
end
