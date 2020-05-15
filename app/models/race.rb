class Race < ApplicationRecord
  has_many :combinations, -> { order(:rane => :desc) }, foreign_key: :race_id, dependent: :destroy
  has_many :combination_fours, foreign_key: :race_id, dependent: :destroy
  has_many :ranks, -> { order(:rane => :desc) }, foreign_key: :race_id, dependent: :destroy
  has_many :results, -> { order(:rane => :desc) }, foreign_key: :race_id, dependent: :destroy

end
