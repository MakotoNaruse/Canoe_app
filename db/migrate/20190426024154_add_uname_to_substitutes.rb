class AddUnameToSubstitutes < ActiveRecord::Migration[5.2]
  def change
    add_column :substitutes, :u_name, :string
  end
end
