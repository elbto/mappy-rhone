require 'csv'
require 'geojson'
require 'rgeo/geo_json'

Gare.destroy_all
Commune.destroy_all

#-----------------------------------------------------------------------
#-------------------------SEEDS FOR COMMUNES----------------------------
#-----------------------------------------------------------------------

puts "STARTING SEEDS FOR COMMUNE"

csv_text = File.read(Rails.root.join('db', 'csvDB', 'data_commune.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
csv.each do |row|
  puts row.to_hash
  commune = Commune.new
  commune.name = row['nom_commune'].downcase
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

#-----------------------------------------------------------------------
#-------------------------SEEDS FOR GARES-------------------------------
#-----------------------------------------------------------------------

csv_text = File.read(Rails.root.join('db', 'csvDB', 'data_gares_rhone.csv'))
csv = CSV.parse(csv_text, :headers => true, :col_sep => ";",:encoding => 'UTF-8')
csv.each do |row|
  x = row['COMMUNE'].downcase
  commune = Commune.find_by(name: x)
  gare = Gare.new
  if commune
    gare.commune = commune
    gare.latitude = row['LATITUDE']
    gare.longitude = row['LONGITUDE']
    gare.save!
    puts "#{gare.latitude}, #{gare.longitude} #{gare.commune.name}---saved"
  end
end


# filepath = "db/csvDB/pharmacies.csv"
# CSV.foreach(filepath, headers: :first_row) do |row|
#   #dans chaque row on a le nom, l'adresse, le cp, lattitude et longitude de la pharamcie
#   #il faut attendre de créer les zones pour ensuite lié les pharmacie à la zone
# end
