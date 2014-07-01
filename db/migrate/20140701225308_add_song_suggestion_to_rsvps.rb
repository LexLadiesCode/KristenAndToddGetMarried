class AddSongSuggestionToRsvps < ActiveRecord::Migration
  def change
    add_column :rsvps, :song_suggestion, :string
  end
end
