class Race < ApplicationRecord
  has_many :combinations, foreign_key: :race_id, dependent: :destroy
  has_many :ranks, foreign_key: :race_id, dependent: :destroy
  has_many :results, foreign_key: :race_id, dependent: :destroy
end
