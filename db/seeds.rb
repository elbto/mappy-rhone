# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

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
