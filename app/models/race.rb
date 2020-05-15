class Race < ApplicationRecord
  has_many :combinations, -> { order(:rane) }, foreign_key: :race_id, dependent: :destroy
  has_many :combination_fours, foreign_key: :race_id, dependent: :destroy
  has_many :ranks, -> { order(:rane) }, foreign_key: :race_id, dependent: :destroy
  has_many :results, -> { order(:rane) }, foreign_key: :race_id, dependent: :destroy

end
