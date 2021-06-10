class Pet < ApplicationRecord
  belongs_to :user
  has_many :pictures, as: :imageable

  validates :name, :user, presence: true

  validates :name, length: { maximum: 256 }
  validates :description, length: { maximum: 1024 }

  def birthDate
    birth_date.strftime("%d/%m/%Y")
  end

  def set_profile_picture(image)
    picture_id = SecureRandom.uuid

    $client_redis.set("image_#{picture_id}", image)
    self.profile_picture = picture_id
  end

  def add_picture(image)
    picture_id = SecureRandom.uuid

    $client_redis.set("image_#{picture_id}", image)

    picture = Picture.new
    picture.image_id = picture_id
    self.pictures << picture
  end
  
  def delete_picture_by_id(id)
    $client_redis.del("image_#{id}")
  end

  def get_image_by_id(id)
    $client_redis.get("image_#{id}")
  end
end
