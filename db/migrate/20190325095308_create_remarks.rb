class CreateRemarks < ActiveRecord::Migration[5.2]
  def change
    create_table :remarks do |t|
      t.references :race, foreign_key: true
      t.integer :rane
      t.integer :rank

      t.timestamps
    end
  end
end
