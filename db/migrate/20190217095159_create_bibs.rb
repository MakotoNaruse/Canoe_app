class CreateBibs < ActiveRecord::Migration[5.2]
  def change
    create_table :bibs do |t|
      t.references :player, foreign_key: true
      t.string :bib_no
      t.integer :tour

      t.timestamps
    end
  end
end
