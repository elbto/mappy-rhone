class CommunesController < ApplicationController
  def index
    if params[:address].present?
      @address = params[:address]
    else
      @communes = Commune.all
    end
    if params[:price_query].present?
      @communes = @communes.where("price < ?", params[:price_query])
    end
  end

  def geojson
    coordonnes = []
    @communes = Commune.all
    @communes = @communes.where('price <= ?', params[:price_query]) if params[:price_query].present?
    p "la y a le prix #{params[:price_query]}"
    @communes.each do |commune|
      coordonnes << commune.polygon[0]
    end


    json = {
      'type': 'Feature',
      'geometry': {
        'type': 'Polygon',
        'coordinates': coordonnes
      }
    }

    render json: json
  end
end
