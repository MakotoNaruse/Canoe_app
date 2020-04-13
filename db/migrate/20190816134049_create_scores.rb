class CreateScores < ActiveRecord::Migration[5.2]
  def change
    create_table :scores do |t|
      t.string :u_name
      t.integer :year
      t.integer :tour
      t.float :mk_score
      t.float :mc_score
      t.float :m_score
      t.float :jmk_score
      t.float :jmc_score
      t.float :jm_score
      t.float :wk_score
      t.float :wc_score
      t.float :w_score
      t.float :jwk_score
      t.float :jwc_score
      t.float :jw_score

      t.timestamps
    end
  end
end
