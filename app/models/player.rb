class Player < ApplicationRecord
  has_many :entries
  has_many :pairs
  has_many :pair_twos
  has_many :bibs
  validates :p_name, presence: true
end
