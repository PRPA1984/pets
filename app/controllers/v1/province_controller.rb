class V1::ProvinceController < ApplicationController
  
  def index
    provinces = Province.all.as_json(
      only: [:id, :name]
    )

    render(json: provinces, status: 200)
  end
end
