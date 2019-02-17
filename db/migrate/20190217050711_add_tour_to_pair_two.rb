class AddTourToPairTwo < ActiveRecord::Migration[5.2]
  def change
    add_column :pair_twos, :tour, :integer
  end
end
