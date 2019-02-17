class AddTourToFour < ActiveRecord::Migration[5.2]
  def change
    add_column :fours, :tour, :integer
  end
end
