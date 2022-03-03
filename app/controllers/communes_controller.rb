class CommunesController < ApplicationController
  def index
    if params[:address].present?
      @address = params[:address]
    else
      @communes = Commune.all
    end
  end
end
