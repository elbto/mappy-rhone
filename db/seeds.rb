require "csv"

filepath = "db/csvDB/pharmacies.csv"

CSV.foreach(filepath, headers: :first_row) do |row|
  #dans chaque row on a le nom, l'adresse, le cp, lattitude et longitude de la pharamcie
  #il faut attendre de créer les zones pour ensuite lié les pharmacie à la zone
end
