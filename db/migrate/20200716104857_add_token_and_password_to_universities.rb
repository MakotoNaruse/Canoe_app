class AddTokenAndPasswordToUniversities < ActiveRecord::Migration[5.2]
  def change
    add_column :universities, :password_digest, :string, null: true, defalut: nil
    add_column :universities, :reset_token, :string, null: true, default: nil
  end
end
