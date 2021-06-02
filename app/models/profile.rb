class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :province, optional: true

  def add_picture!(image)
    picture_id = picture || SecureRandom.uuid

    $client_redis.set("image_#{picture_id}", image)
    
    update(picture: picture_id) if picture_id != picture
  end
end
