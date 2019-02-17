class PairTwo < ApplicationRecord
  belongs_to :player
  validates :pair_id, presence: true
end
