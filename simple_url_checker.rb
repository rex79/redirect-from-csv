require 'net/http'
require 'csv'

missing = []
no_new_url = []
counting = CSV.read('no-prodotti.txt', { col_sep: ' '}).length

CSV.foreach('no-prodotti.txt', { col_sep: ' ' } ).each_with_index do |url, index|
    to = "https://www.kasanova.com#{url[0]}"

    begin
        puts "parsing #{index} of #{counting} - #{to}"
        response = Net::HTTP.get_response(URI(to))

        if response.code == '404'
            puts "Wrong redirect - #{to} - check if new match"
            if nresponse.code == '200'
                puts "Puts new redirect"
                missing.push("#{to} #{url[1]}")
            else
                no_new_url.push("#{to} #{url[1]}")
            end
        else
            puts "redirect OK"
        end
    rescue
        no_new_url.push("#{to} #{url[1]}")
        puts "going on"
    end

end
mfile = File.open('all_final.txt', 'w')
missing.each do |line|
    mfile.puts line +"\r"
end
mfile.close

wrong = File.open('all_final_wrong.txt', 'w')
no_new_url.each do |line|
    wrong.puts line +"\r"
end
wrong.close

puts "find #{missing.count} on #{counting}"
puts "find #{no_new_url.count} on #{counting}"
