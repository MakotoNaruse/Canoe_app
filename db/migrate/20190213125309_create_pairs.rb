class CreatePairs < ActiveRecord::Migration[5.2]
  def change
    create_table :pairs do |t|
      t.integer :pair_id
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end
