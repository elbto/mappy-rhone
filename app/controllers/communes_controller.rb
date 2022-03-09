class CommunesController < ApplicationController
  def index
    @gares = Gare.all
    @gare_markers = @gares.map do |gare|
      {
        lat: gare.latitude,
        lng: gare.longitude,
        image_url: helpers.asset_url('train.png')
      }
    end
  end

  def geojson
    communes = display_commune
    @communes = distance_bet(communes)
    features = @communes.map do |commune|
      {
        'type': 'Feature',
        'geometry': {
          'type': 'Polygon',
          'coordinates': commune.polygon
        },
        'properties': {
          'description': "<h4>#{commune.name.capitalize}</h4>
                          <div class='pop-flex'>
                            <h5>Prix €/m²</h5>
                            <p>#{commune.price.to_i}</p>
                          </div>
                          <div class='pop-flex'>
                            <h5>Pharmacies</h5>
                            <p>#{commune.pharmacies.count}</p>
                          </div>
                          <div class='pop-flex'>
                            <h5>Gares</h5>
                            <p>#{commune.gares.count}</p>
                          </div>
                          <div class='pop-flex'>
                            <h5>Ecoles</h5>
                            <p>#{commune.ecoles.count}</p>
                          </div>",
          'color': color_get(commune)
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
    max_price = params[:price_query].to_f * 1.10
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
    max_price = params[:price_query].to_f * 1.10
    p max_price
    price = commune.price
    p price
    if price / max_price >= 0.98
      return '#e6a13d'
        # doit retourner '#FFB344', mais n'affiche rien
        # la couleur est à matcher avec la variable SCSS $echo dans _colors.scss
    elsif price / max_price <= 0.88
      return '#58a4b7'
        # la couleur est à matcher avec la variable SCSS $charlie dans _colors.scss
    else
      return '#00726e'
        # la couleur est à matcher avec la variable SCSS $delta dans _colors.scss
    end
  end
end
