class AddUniversityToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_reference :players, :university, foreign_key: true
  end
end
