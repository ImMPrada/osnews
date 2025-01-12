class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.index :name, unique: true

      t.timestamps
    end
  end
end
