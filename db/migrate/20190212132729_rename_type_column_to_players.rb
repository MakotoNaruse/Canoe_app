class RenameTypeColumnToPlayers < ActiveRecord::Migration[5.2]
  def change
    rename_column :players, :type, :typ
  end
end
