class CommunesController < ApplicationController
  def index
    # if params[:address].present?
    #   @address = params[:address]
    # else
    #   @communes = Commune.all
    # end
    # if params[:price_query].present?
    #   @communes = @communes.where("price < ?", params[:price_query])
    # end
    @communes = 1
  end

  def geojson
    @address = params[:address]
    coordonnes = []
    @communes = Commune.all
    @communes = @communes.where('price <= ?', params[:price_query]) if params[:price_query].present?
    p "la y a le prix #{params[:price_query]}"
    @communes.each do |commune|
      coordonnes << commune.polygon[0]
    end
    p "voila ta d'address #{@address}"
    p "voila ton priice #{params[:price_query]}"


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
