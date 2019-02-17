class Player < ApplicationRecord
  has_many :entries
  has_many :pairs
  has_many :pair_twos
  validates :p_name, presence: true
end
