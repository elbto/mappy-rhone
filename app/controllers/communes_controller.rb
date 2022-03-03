class CommunesController < ApplicationController
  def index
    if params[:address].present?
      @address = params[:address]
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
