class CommunesController < ApplicationController
  def index
    if params[:query].present?
      @commune = Commune.find_by(name: params[:query])
      @gares = @commune.gares
    else
      @communes = Commune.all
    end
  end
end
