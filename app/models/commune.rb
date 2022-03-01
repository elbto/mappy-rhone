class Commune < ApplicationRecord
  has_many :gares
  has_many :ecoles
  has_many :pharmacies
end
