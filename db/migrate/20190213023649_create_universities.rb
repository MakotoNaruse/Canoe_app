class CreateUniversities < ActiveRecord::Migration[5.2]
  def change
    create_table :universities do |t|
      t.string :u_name
      t.string :read
      t.string :password

      t.timestamps
    end
  end
end
