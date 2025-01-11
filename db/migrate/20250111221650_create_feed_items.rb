class CreateFeedItems < ActiveRecord::Migration[8.0]
  def change
    create_table :feed_items do |t|
      t.string :name
      t.text :description
      t.datetime :publication_date
      t.index :name

      t.references :company, null: false, foreign_key: true
      t.timestamps
    end
  end
end
