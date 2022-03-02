class AddAddressToEcoles < ActiveRecord::Migration[6.1]
  def change
    add_column :ecoles, :address, :string
  end
end
