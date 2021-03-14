class Role < ApplicationRecord
  has_many :permissions

  validates :name, presence: true
end
