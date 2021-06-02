class V1::ProvinceController < ApplicationController
  
  def index
    provinces = Province.all.as_json(
      only: [:id, :name]
    )

    render(json: provinces, status: 200)
  end

  def show
  end

  def create
  end

  def destroy
  end
end
