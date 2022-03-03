class ChangeTypeToNameInEcoles < ActiveRecord::Migration[6.1]
  def change
    remove_column :ecoles, :type
    add_column :ecoles, :name, :string
  end
end
