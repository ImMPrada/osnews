class CreateGuilds < ActiveRecord::Migration[8.0]
  def change
    create_table :guilds do |t|
      t.string :external_id
      t.string :channel_id

      t.index %i[external_id channel_id], unique: true
      t.timestamps
    end
  end
end
