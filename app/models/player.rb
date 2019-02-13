class Player < ApplicationRecord
  has_many :entries
  validates :p_name, presence: true
end
