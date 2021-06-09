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
    hash[:profilePicture] = current_pet.get_image_by_id(current_pet.profile_picture)
    hash[:pictures] = []
    current_pet.pictures.each do |pic|
      hash[:pictures] << current_pet.get_image_by_id(pic)
    end
    render(
      json: hash,
      status: 200
    )
  end

  def create
    pet = current_user.pets.new(pet_params)

    pet.set_profile_picture(params[:profilePicture]) if params[:profilePicture].present?

    if params[:pictures].present?
      params[:pictures].each do |pic|
        pet.add_picture(pic)
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
    pets = Pet.where("name like ?", params[:search])
    pets.map do |pet|
      return {
        "name": pet.name,
        "description": pet.description
      }
    end
    if pets.present?
      render(json:{er: "h"}, status:200)
    end
  end

  def update
    if params[:profilePicture].present? && params[:profilePicture].id != current_pet.profile_picture
      current_pet.delete_picture_by_id(current_pet.profile_picture)
      current_pet.set_profile_picture(params[:profilePicture])
    end

    if params[:pictures].present?
      params[:pictures].each do |pic|
        if not current_pet.pictures.includes(pic.id)
          current_pet.add_picture(pic.src)
        end
      end
    end

    if current_pet.update(pet_params)
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
    @current_pet = current_user.pets.find_by(id: params[:id])
  end

  def check_pet
    return if current_pet.present?

    render(
      json: format_error(request.path, "No existe la moscota con el id #{params[:id]}"),
      status: 401
    )
  end

  def pet_params
    result = params.require(:pet).permit(:name, :description).to_h
    result.merge(birth_date: params['birthDate'])
  end
end
  
