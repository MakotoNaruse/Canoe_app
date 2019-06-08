class CreateSubstitutes < ActiveRecord::Migration[5.2]
  def change
    create_table :substitutes do |t|
      t.integer :main_id
      t.string :race_name
      t.integer :sub_id
      t.integer :year
      t.integer :tour

      t.timestamps
    end
  end
end
