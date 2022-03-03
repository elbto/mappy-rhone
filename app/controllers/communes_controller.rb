class CommunesController < ApplicationController
  def index
  end

  def geojson
    @communes = display_comune
    json = {
      'type': 'Feature',
      'geometry': {
        'type': 'Polygon',
        'coordinates': coordonnes_display(@communes)
      }
    }
    render json: json
  end

  private

  def distance_between
    a = [4.8268726, 45.7532826]
    center = [4.835659, 45.764043]
    Geocoder::Calculations.to_kilometers(Geocoder::Calculations.distance_between(center,a))
  end

  def coordonnes_display(communes)
    coordonnes = []
    communes.each do |commune|
      coordonnes << commune.polygon[0]
    end
    coordonnes
  end

  def display_comune
    @communes = Commune.all
    @communes = @communes.where('price <= ?', params[:price_query]) if params[:price_query].present?
    @communes
  end

end
