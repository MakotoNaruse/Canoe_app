class University < ApplicationRecord
  has_secure_password

  has_many :fours

  validates :u_name, presence: true
  validates :read, presence: true
  validates :erea, presence: true
end
