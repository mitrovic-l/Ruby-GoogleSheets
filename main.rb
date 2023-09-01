require 'google_drive'
require './test.rb'
session = GoogleDrive::Session.from_config("config.json")
ws = session.spreadsheet_by_key("1y__Our5L7vXtvf7GIa-flv9sT3uebCz9Ht-ZohbR3iA").worksheets[0]
ws2 = session.spreadsheet_by_key("1y__Our5L7vXtvf7GIa-flv9sT3uebCz9Ht-ZohbR3iA").worksheets[1]
ws3 = session.spreadsheet_by_key("1y__Our5L7vXtvf7GIa-flv9sT3uebCz9Ht-ZohbR3iA").worksheets[2]

# Testiranje funkcionalnosti

# Biblioteka može da vrati dvodimenzioni niz sa vrednostima tabele
t1 = read_table(ws)
t2 = read_table(ws2)
t3 = read_table(ws3)
# p t1
t1.eachCell do |cell|
  puts cell
end

# Moguće je pristupati redu preko t.row(1),
# i pristup njegovim elementima po sintaksi niza.
# p t1.row(0)
# p t2.row(1)

# Mora biti implementiran Enumerable modul(each funkcija),
# gde se vraćaju sve ćelije unutar tabele, sa leva na desno
# t2.eachCell do |cell|
#  puts cell
# end

# Biblioteka treba da vodi računa o merge-ovanim poljima

# Biblioteka vraća celu kolonu kada se napravi upit t[“Prva Kolona”]
# p t1["Prva kolona"]
# Biblioteka omogućava pristup vrednostima unutar kolone po sledećoj sintaksi
# t[“Prva Kolona”][1] za pristup drugom elementu te kolone
# p t1["Prva kolona"][1]

# Biblioteka omogućava direktni pristup kolonama, preko istoimenih metoda.
# p t1.Prvakolona
# p t2.kol1

# Subtotal/Average  neke kolone se može sračunati preko sledećih sintaksi
# p t3.kol2.sum
# p t3.kol2.avg

# Iz svake kolone može da se izvuče pojedinačni red na osnovu vrednosti jedne od ćelija.
# (smatraćemo da ta ćelija jedinstveno identifikuje taj red)
# Primer sintakse: t.indeks.rn2310, ovaj kod će vratiti red studenta čiji je indeks rn2310
# p t1.Indeks.rn6120

# Biblioteka prepoznaje ukoliko postoji na bilo koji način ključna reč total ili subtotal unutar sheet-a,
# i ignoriše taj red
# [U t1 ima "total" rec i ignorise se ceo red]

# Moguce je sabiranje dve tabele, sve dok su im headeri isti.
# Npr t1+t2, gde svaka predstavlja, tabelu unutar jednog od worksheet-ova.
# Rezultat će vratiti novu tabelu gde su redovi(bez headera) t2 dodati unutar t1.
# (SQL UNION operacija)
# t4 = t2+t3
# t4.print_trtable
# Stampam trTable zbog lakse preglednosti

# Moguce je oduzimanje dve tabele, sve dok su im headeri isti.
# Npr t1-t2, gde svaka predstavlja reprezentaciju jednog od worksheet-ova.
# Rezultat će vratiti novu tabelu gde su svi redovi iz t2 uklonjeni iz t1, ukoliko su identicni.
# t5 = t3-t2
# t5.print_trtable

# Biblioteka prepoznaje prazne redove, koji mogu biti ubačeni izgleda radi
ws.reload
