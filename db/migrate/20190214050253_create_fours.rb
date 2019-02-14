class CreateFours < ActiveRecord::Migration[5.2]
  def change
    create_table :fours do |t|
      t.string :race_name
      t.references :university, foreign_key: true

      t.timestamps
    end
  end
end
