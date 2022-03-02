class ChangeTypeFromEcole < ActiveRecord::Migration[6.1]
  def change
    remove_column :ecoles, :type
    add_column :ecoles, :statut, :string
  end
end
