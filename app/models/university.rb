class University < ApplicationRecord
  validates :u_name, presence: true
  validates :read, presence: true
  validates :erea, presence: true
  validates :password, presence: true
end
