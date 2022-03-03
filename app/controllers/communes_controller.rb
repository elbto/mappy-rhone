class CommunesController < ApplicationController
  def index
    if params[:query].present?
      @commune = Commune.find_by(name: params[:query])
      @gares = @commune.gares
    else
      @communes = Commune.all
    end
    if params[:price_query].present?
      @communes = @communes.where("price < ?", params[:price_query])
      #("id > ?", 200)
      #@flats = @flats.where("price_per_night <= ?", params[:max_price])
    end
  end
end
