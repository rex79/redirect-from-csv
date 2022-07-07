require 'net/http'
require 'csv'

missing = []
no_new_url = []
counting = CSV.read('no-prodotti.txt', { col_sep: ' '}).length

CSV.foreach('no-prodotti.txt', { col_sep: ' ' } ).each_with_index do |url, index|

    if ("https://www.kasanova.com#{url[0]}" == url[1])
        missing.push(url[1])
    end

end

mfile = File.open('all_final.txt', 'w')
missing.each do |line|
    mfile.puts line +"\r"
end
mfile.close
