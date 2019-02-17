class AddTourToPair < ActiveRecord::Migration[5.2]
  def change
    add_column :pairs, :tour, :integer
  end
end
