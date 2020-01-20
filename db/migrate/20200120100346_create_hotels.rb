class CreateHotels < ActiveRecord::Migration[6.0]
  def change
    create_table :hotels do |t|
      t.string :hotel_id, null: false
      t.integer :destination_id, null: false
      t.json :detail

      t.timestamps
    end
  end
end
