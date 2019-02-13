class CreatePairTwos < ActiveRecord::Migration[5.2]
  def change
    create_table :pair_twos do |t|
      t.integer :pair_id
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end
