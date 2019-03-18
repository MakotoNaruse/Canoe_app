class AddYearToFour < ActiveRecord::Migration[5.2]
  def change
    add_column :fours, :year, :integer
  end
end
