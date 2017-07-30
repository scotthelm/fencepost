class CreateAddresses < ActiveRecord::Migration[4.2]
  def change
    create_table :addresses do |t|
      t.integer :person_id
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state_province
      t.string :postal_code

      t.timestamps
    end
  end
end
