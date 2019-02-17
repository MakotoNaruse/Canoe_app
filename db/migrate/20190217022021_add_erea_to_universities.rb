class AddEreaToUniversities < ActiveRecord::Migration[5.2]
  def change
    add_column :universities, :erea, :string
  end
end
