class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.integer :year
      t.string :u_name
      t.string :p_name
      t.string :type
      t.integer :grade

      t.timestamps
    end
  end
end
