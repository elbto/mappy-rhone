class CommunesController < ApplicationController
  def index
  end

  def geojson
    communes = display_commune
    @communes = distance_bet(communes)
    # @communes.each do |commune|
    #   color_get(commune)
    # end
    features = @communes.map do |commune|
      {
        'type': 'Feature',
        'geometry': {
          'type': 'Polygon',
          'coordinates': commune.polygon
        },
        'properties': {
          'com_name': commune.name,
          'color': color_get(commune),
          'price': commune.price
        }
      }
    end

    json = {
      "type": "FeatureCollection",
      "features": features
    }

    render json: json

  end

  private

  def display_commune
    @communes = Commune.all
    max_price = params[:price_query].to_f * 1.05
    @communes = @communes.where('price <= ?', max_price) if params[:price_query].present?
    return @communes
  end

  def distance_bet(communes)
    final_communes = []
    distance = params[:distance].to_f
    lat = params[:lat].to_f
    long = params[:long].to_f
    center = [long, lat]
    communes.each do |commune|
      commune_center = [commune.longitude, commune.latitude]
      if Geocoder::Calculations.to_kilometers(Geocoder::Calculations.distance_between(center, commune_center)) <= distance
        final_communes << commune
      end
    end
    final_communes
  end

  def coordonnes_display(communes)
    coordonnes = []
    communes.each do |commune|
      coordonnes << commune.polygon[0]
    end
    coordonnes
  end

  def color_get(commune)
    max_price = params[:price_query].to_f * 1.05
    p max_price
    price = commune.price
    p price
    if price / max_price >= 0.95
      return '#05361a'
    elsif price / max_price <= 0.85
      return '#096a32'
    else
      return '#5b8a73'
    end
  end
end
