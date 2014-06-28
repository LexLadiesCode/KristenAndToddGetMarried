class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :guest_count
      t.boolean :attending
      t.string :song_suggestion

      t.timestamps
    end
  end
end
