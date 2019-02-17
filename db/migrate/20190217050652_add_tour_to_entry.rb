class AddTourToEntry < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :tour, :integer
  end
end
