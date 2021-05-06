class Role < ApplicationRecord
  has_many :permissions

  validates :name, uniqueness: true
end
