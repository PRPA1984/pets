class V1::ProfileController < ApplicationController
  before_action :check_token, only: [:show, :create, :picture]

  def show
    if current_user.profile.present?
      render(
        json: current_user.profile.as_json(
          only: [
            :name,
            :phone,
            :email,
            :address,
            :providence_id,
            :picture
          ]
        ),
        status: 200
      )
    else
      render(
        json: format_error(request.path, "No hay profile"),
        status: 401
      )
    end
  end

  def create
    profile = if current_user.profile.present?
                current_user.profile
              else
                Profile.new(user_id: current_user.id)
              end

    profile.assign_attributes(profile_params)

    if profile.save
      render(
        json: profile.as_json(
          only: [
            :name,
            :phone,
            :email,
            :address,
            :providence_id,
            :picture
          ]
        ),
        status: 200
      )
    else
      render(
        json: format_error(request.path, profile.errors.full_messages),
        status: 401
      )
    end
  end

  def picture
  end

  private

  def profile_params
    params.require(:profile).permit(
      :name,
      :phone,
      :email,
      :address,
      :providence
    )
  end
end
