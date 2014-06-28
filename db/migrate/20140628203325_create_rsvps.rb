class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.integer :guestcount
      t.boolean :attending

      t.timestamps
    end
  end
end
