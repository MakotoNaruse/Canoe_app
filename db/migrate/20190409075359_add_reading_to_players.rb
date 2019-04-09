class AddReadingToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :reading, :string
  end
end
