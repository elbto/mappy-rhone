class RemoveZipcodFromCommune < ActiveRecord::Migration[6.1]
  def change
    remove_column :communes, :zipcod, :integer
  end
end
