class RemoveStatutsFromEcole < ActiveRecord::Migration[6.1]
  def change
    remove_column :ecoles, :statut
    add_column :ecoles, :type, :string
  end
end
