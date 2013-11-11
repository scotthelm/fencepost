class CreateAddressTypes < ActiveRecord::Migration
  def change
    create_table :address_types do |t|
      t.string :key
      t.string :label

      t.timestamps
    end
  end
end
