class Entry < ApplicationRecord
  belongs_to :player
  validates :player_id, presence: true
end
