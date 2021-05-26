class Pet < ApplicationRecord
  belongs_to :user

  validates :name, :user, presence: true

  validates :name, length: { maximum: 256 }
  validates :description, length: { maximum: 1024 }

  def birthDate
    birth_date.strftime("%d/%m/%Y")
  end
end
