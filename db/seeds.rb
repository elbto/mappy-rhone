# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "csv"
require 'geojson'
require 'rgeo/geo_json'

Commune.destroy_all


csv_text = File.read(Rails.root.join('db', 'csvDB', 'data_commune.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
csv.each do |row|
  puts row.to_hash
  commune = Commune.new
  commune.name = row['nom_commune']
  commune.zipinsee = row['code_commune']
  commune.price = row['carre']

  commune.save!
  puts "#{commune.name}, #{commune.price} #{commune.zipinsee}saved"
end

puts "SEEDS COMMUNES OK"



file_geo = "db/csvDB/69commune.geojson"
geo_data = File.read(file_geo)
geom = RGeo::GeoJSON.decode(geo_data)
geom.each do |x|
  commune = Commune.find_by(zipinsee: x['com_code'])
  if commune != nil
    p commune.name
    commune.latitude = x['geo_point_2d'][0]
    commune.longitude = x['geo_point_2d'][1]
    commune.polygon = x.geometry.coordinates
    commune.save!
    p commune.name
  end
end

p "lat & long added"


# filepath = "db/csvDB/pharmacies.csv"
# CSV.foreach(filepath, headers: :first_row) do |row|
#   #dans chaque row on a le nom, l'adresse, le cp, lattitude et longitude de la pharamcie
#   #il faut attendre de créer les zones pour ensuite lié les pharmacie à la zone
# end
