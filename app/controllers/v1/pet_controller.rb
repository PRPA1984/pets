class V1::PetController < ApplicationController
  before_action :check_token, only: [:index, :show, :create, :update, :destroy]
  before_action :check_pet, only: [:show, :update, :destroy]

  def index
    pets = current_user.pets.as_json(
      only: [:id, :name, :description],
      methods: [:birthDate]
    )
    render(json: pets, status: 200)
  end

  def show
    hash = current_pet.as_json(
      only: [:id, :name, :description],
      methods: [:birthDate]
    )
    hash[:profilePicture] = {
      src: current_pet.get_image_by_id(current_pet.profile_picture),
      id: current_pet.profile_picture
    }
    hash[:pictures] = []
    current_pet.pictures.each do |pic|
      hash[:pictures] << {
        src: current_pet.get_image_by_id(pic.image_id),
        id: pic.image_id
      }
    end
    puts(hash)
    render(
      json: hash,
      status: 200
    )
  end

  def create
    pet = current_user.pets.new(pet_params)

    pet.set_profile_picture(params[:profilePicture][:src]) if params[:profilePicture][:src].present?

    if params[:pictures].present?
      params[:pictures].each do |pic|
        pet.add_picture(pic[:src])
      end
    end

    if pet.save
      render(
        json: pet.as_json(
          only: [:id, :name, :description],
          methods: [:birthDate]
        ),
        status: 200
      )
    else
      render(
        json: format_error(request.path, pet.errors.full_messages),
        status: 401
      )
    end
  end

  def search
    pets = Pet.where("name like ?","%#{params[:search]}%")
    pets = pets.map do |pet|
      {
        "id": pet.id,
        "name": pet.name,
        "description": pet.description,
        "profilePicture": {
          "src": pet.get_image_by_id(pet.profile_picture),
          "id": pet.profile_picture
        }
      }
    end
    render(json: pets, status:200)
  end

  def update

    if params[:profilePicture].present? && params[:profilePicture][:id] != current_pet.profile_picture
      current_pet.delete_picture_by_id(current_pet.profile_picture)
      current_pet.set_profile_picture(params[:profilePicture][:src])
    end

    if params[:pictures].present?
      pics_ids = params[:pictures].map do |pic|
        if pic[:id].blank?
          current_pet.add_picture(pic[:src])
        end
        pic[:id]
      end

      current_pet.pictures.each do |pic|
        if not pics_ids.include?(pic.image_id)
          current_pet.delete_picture_by_id(pic.image_id)
          current_pet.pictures.delete(pic)
        end
      end
    end
    current_pet.name = pet_params[:name]
    current_pet.description = pet_params[:description]
    current_pet.birth_date = pet_params[:birth_date]
    if current_pet.save
      render(
        json: current_pet.as_json(
          only: [:id, :name, :description],
          methods: [:birthDate]
        ),
        status: 200
      )
    else
      render(
        json: format_error(request.path, current_pet.errors.full_messages),
        status: 401
      )
    end
  end

  def destroy
    if current_pet.destroy
      render(status: 200)
    else
      render(
        json: format_error(request.path, current_pet.errors.full_messages),
        status: 401
      )
    end
  end

  private

  def current_pet
    @current_pet ||= current_user.pets.find_by(id: params[:id])
  end

  def check_pet
    return if current_pet.present?

    render(
      json: format_error(request.path, "No existe la mascota con el id #{params[:id]}"),
      status: 401
    )
  end

  def pet_params
    result = params.require(:pet).permit(:name, :description).to_h
    result.merge(birth_date: params['birthDate'])
  end
end
  
