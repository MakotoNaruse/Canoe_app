class DeletePasswordFromUniversity < ActiveRecord::Migration[5.2]
  def change
    remove_column :universities, :password
  end
end
