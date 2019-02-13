class CreateEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :entries do |t|
      t.string :race_name
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end
