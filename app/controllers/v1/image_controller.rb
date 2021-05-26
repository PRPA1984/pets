class V1::ImageController < ApplicationController
  before_action :check_token, only: [:show, :create]

  def show
    image = $client_redis.get("image_#{params[:id]}")

    if image.present?
      render(
        json: { name: 'Base64', type: 'text', description: image },
        status: 200
      )
    else
      render(
        format_error(request.path, "No existe la imagen con el id #{params[:id]}"),
        status: 401
      )
    end
  end

  def create
    if params["image"].present?
      id = SecureRandom.uuid

      $client_redis.set("image_#{id}", params["image"])
      render(
        json: { id: id },
        status: 200
      )
    else
      render(
        format_error(request.path, "No me pasaste nada"),
        status: 401
      )
    end
  end
end
