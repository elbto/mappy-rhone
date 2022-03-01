class AddColumnLatLongToCommune < ActiveRecord::Migration[6.1]
  def change
    add_column :communes, :latitude, :decimal
    add_column :communes, :longitude, :decimal
  end
end
