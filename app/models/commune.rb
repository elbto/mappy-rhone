class Commune < ApplicationRecord
  has_many :gares
  has_many :ecoles
end
