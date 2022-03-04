class CommunesController < ApplicationController
  def index
  end

  def geojson
    @communes = display_comune
    communes = distance_bet(@communes)
    json = {
      'type': 'Feature',
      'geometry': {
        'type': 'Polygon',
        'coordinates': coordonnes_display(communes)
      }
    }
    render json: json
  end

  private

  def display_comune
    @communes = Commune.all
    @communes = @communes.where('price <= ?', params[:price_query]) if params[:price_query].present?
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
end
