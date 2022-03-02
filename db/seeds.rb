require "csv"
require 'rgeo/geo_json'
require 'json'


Pharmacie.destroy_all
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

#-----------------------------------------------------------------------
#-------------------------SEEDS FOR COORONATES----------------------------
#-----------------------------------------------------------------------
coo = 0

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
    coo += 1
  end
end

file_geo = "db/csvDB/adr_voie_lieu.json"
geo_data = File.read(file_geo)
geom = JSON.parse(geo_data)
geom['features'].each do |x|
  zip = x['properties']["insee"] #la j'ai code insée
  coordonnes = x["geometry"]["coordinates"] #la j'ai coordoné
  commune = Commune.find_by(zipinsee: zip)
  if commune != nil
    commune.polygon = coordonnes
    commune.save!
    p commune.name
    coo += 1
  end
end
 p "#{coo} coordonées ont été ajoutées"

 p "ADD coordinates to Lyon 1 a 9e arrondissement"

lyon1 = Commune.find_by(name: "Lyon 1e Arrondissement")
lyon1.latitude = "45.7695061"
lyon1.longitude = "4.8301275"
lyon1.save!
lyon2 = Commune.find_by(name: "Lyon 2e Arrondissement")
lyon2.latitude ="45.7532826"
lyon2.longitude ="4.8268726"
lyon2.save!
lyon3 = Commune.find_by(name: "Lyon 3e Arrondissement")
lyon3.latitude = "45.7600589"
lyon3.longitude = "4.8495363"
lyon3.save!
lyon4 = Commune.find_by(name: "Lyon 4e Arrondissement")
lyon4.latitude = "45.774330139160156"
lyon4.longitude = "4.827831268310547"
lyon4.save!
lyon5 = Commune.find_by(name: "Lyon 5e Arrondissement")
lyon5.latitude = "45.76359558105469"
lyon5.longitude = "4.827502727508545"
lyon5.save!
lyon6 = Commune.find_by(name: "Lyon 6e Arrondissement")
lyon6.latitude = "45.76831817626953"
lyon6.longitude = "4.849535942077637"
lyon6.save!
lyon7 = Commune.find_by(name: "Lyon 7e Arrondissement")
lyon7.latitude = "45.746299743652344"
lyon7.longitude = "4.841841220855713"
lyon7.save!
lyon8 = Commune.find_by(name: "Lyon 8e Arrondissement")
lyon8.latitude = "45.736366271972656"
lyon8.longitude = "4.869597911834717"
lyon8.save!
lyon9 = Commune.find_by(name: "Lyon 9e Arrondissement")
lyon9.latitude = "45.77389144897461"
lyon9.longitude = "4.805800437927246"
lyon9.save!
puts "END coordinates to Lyon 1 a 9e arrondissement SAVED"

#-----------------------------------------------------------------------
#-------------------------SEEDS FOR PHARMACIES----------------------------
#-----------------------------------------------------------------------

pharma_created = 0
filepath = "db/csvDB/pharmacies.csv"
CSV.foreach(filepath) do |row|
  a = row[0].split(';')
  p a
  pharma_name = a[0]
  pharma_address = a[1]
  pharma_zip_code = a[2].split[0]
  name = a[2].split[1..-1].join(' ')
  p name
  lat = a[3]
  long = a[4]
  if name != "Lyon"
    commune = Commune.find_by(name: name)
  else
    commune = Commune.find_by(name: "Lyon #{pharma_zip_code[-1]}e Arrondissement")
  end
  if commune != nil
    pharmacie = Pharmacie.new(
      name: pharma_name,
      address: pharma_address,
      zip_code: pharma_zip_code,
      lattitude: lat,
      longitude: long,
      city: name
      )
    pharmacie.commune = commune
    pharmacie.save!
     pharma_created += 1
  end
end

puts "#{pharma_created} ont ete crée"
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

puts "Gares were created"
