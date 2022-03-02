class PagesController < ApplicationController
  def home
    @communes = Commune.all
  end
end
