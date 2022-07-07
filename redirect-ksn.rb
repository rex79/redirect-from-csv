require 'net/http'
require 'csv'

missing = []
no_new_url = []
counting = CSV.read('redirect-non-prodotti-kasanova-elaborated.csv', { col_sep: ';'}).length

CSV.foreach('redirect-non-prodotti-kasanova-elaborated.csv', { col_sep: ';' } ).each_with_index do |url, index|
    to = url[0]

    begin
        puts "parsing #{index} of #{counting} - #{url[0]}"
        missing.push("#{to} https://www.kasanova.com#{url[1]}")
    rescue
        no_new_url.push("#{to} #{url[1]}")
        puts "going on"
    end
end
mfile = File.open('no-prodotti.txt', 'w')
missing.each do |line|
    mfile.puts line +"\r"
end
mfile.close

puts "find #{missing.count} on #{counting}"
