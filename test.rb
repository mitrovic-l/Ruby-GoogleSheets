require 'google_drive'

# Potrebno za dinamicko kreiranje metoda
def add_method(x, y, &z)
  x.class_eval{
    define_method(y.to_s, &z)
  }
end

class Table
  include Enumerable

  attr_accessor :table, :kolone, :trtable
  attr_reader :table, :kolone, :trtable


  def initialize(matrix)
    @table = matrix
    @kolone = []
    @trtable = @table.transpose
    pristup_kolonama # omogucava korisniku da pristupa preko t.PrvaKolona
    pristup_redu # omogucava korisniku da unese t.indeks.rn6120 i vraca red studenta ciji je indeks rn6120
  end


  def row(rowNumber)
    return @table[rowNumber]
  end

  def eachCell(&block)
    @trtable.each(&block)
  end

  def print_table()
    @table.each do |i|
      i.each do |j|
        puts j
      end
    end
  end

  def print_trtable()
    @trtable.each do |i|
      i.each do |j|
        puts j
      end
    end
  end

  def [](column_name)
    col_hash = hash_za_kolone
    return col_hash[column_name]
  end

  def +(t2)
    tabela1 = @table
    tabela2 = t2.table
    headeri1 = []
    headeri2 = []
    tabela1[0].each do |x|
      headeri1.push(x.to_s)
    end
    tabela2[0].each do |y|
      headeri2.push(y.to_s)
    end
    # puts headeri1
    # puts headeri2
    if (headeri1.to_set!=headeri2.to_set)
      puts "Razliciti headeri, sabiranje nije moguce."
      return nil
    end
    pom = @table
    pom+=tabela2[1..-1] #uzece sve osim headera tabele2 i dodati na tabelu1
    newT = Table.new(pom)
    puts "Odradjeno sabiranje tabela"
    return newT
  end

  def-(t2)
    tabela1 = @table
    tabela2 = t2.table
    headeri1 = []
    headeri2 = []
    tabela1[0].each do |x|
      headeri1.push(x.to_s)
    end
    tabela2[0].each do |y|
      headeri2.push(y.to_s)
    end
    if (headeri1.to_set!=headeri2.to_set)
      puts "Razliciti headeri, sabiranje nije moguce."
      return nil
    end
    pom = @table
    pom-=tabela2[1..-1]
    puts "Odradjeno oduzimanje tabela."
    newT = Table.new(pom)
    return newT
  end

  private
  def hash_za_kolone
    h = Hash.new{|h,k| h[k]=[]}
    @trtable.each do |kolona|
      total_flag = 0
      key = ""
      kolona.each do |value|
        if total_flag == 0
          key = value
          total_flag = 1
        else
          h[key] << value
        end
      end
    end
    return h
  end

  def pristup_kolonama
    brojac = 1
    @table[0].each do |celija|
      brojac2 = brojac - 1
      ime = @table[0][brojac2].delete(' ')
      transponovana = @trtable
      add_method(Table, ime){
        return transponovana[brojac2]
      }
      brojac +=1
    end
  end

  # iz svake kolone može da se izvuče pojedinačni red
  # na osnovu vrednosti jedne od ćelija.
  def pristup_redu
    brojac = 1
    @trtable[0].slice(1..-1).each do |value|
      pomtable = @table
      brojac2 = brojac
      add_method(Array, value.to_s){
        return pomtable[brojac2]
      }
      brojac+=1
    end
  end

end

class Array
  def sum
    suma = 0
    self.each do |value|
      suma+=value.to_i
    end
    return suma
  end

  def avg
    suma = 0
    brojac = 0
    self.each do |value|
      brojac+=1
      suma+=value.to_i
    end
    brojac-=1 # smanjujemo brojac jer ce uhvatiti i header, npr Peta Kolona
    prosek = suma / brojac
    return prosek
  end
end

def read_table(ws)
  table = []
  flag = 0
  topLeftRow = 0
  topLeftCol = 0
  bottomRightRow = ws.num_rows
  bottomRightCol = ws.num_cols

  (1..ws.num_rows).each do |row|
    (1..ws.num_cols).each do |col|
      if (flag==0 && ws[row,col]!="")
        topLeftRow = row
        topLeftCol = col
        flag = 1
      end
    end
  end

  arrayTotalRow = []
  (1..ws.num_rows).each do |row|
    (1..ws.num_cols).each do |col|
      if (ws[row,col]!="")
        if (ws[row,col].include? "total")
          arrayTotalRow.push(row)
        end
        if (ws[row,col].include? "subtotal")
          arrayTotalRow.push(row)
        end
      end
    end
  end

  (1..ws.num_rows).each do |row|
    bool = 0
    helper = []
    (1..ws.num_cols).each do |col|
      if (row>=topLeftRow && col>=topLeftCol && row<=bottomRightRow && col<=bottomRightCol && !(arrayTotalRow.include? row))
        helper.push(ws[row,col])
        bool = 1
      end
    end
    if (bool == 1)
      table.push(helper)
    end
  end
  t = Table.new(table)
  puts "Ucitana tabela"
  return t
end




