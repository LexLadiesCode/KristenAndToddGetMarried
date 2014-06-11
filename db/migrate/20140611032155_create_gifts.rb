class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.string :name
      t.text :description
      t.string :location
      t.string :image_url
      t.integer :cost_cents
      t.integer :amount_received_cents
      t.timestamps
    end
  end
end
