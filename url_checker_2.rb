require 'net/http'
require 'csv'

missing = []
no_new_url = []
counting = CSV.read('csv/all_final.csv', { col_sep: ';'}).length

right_url = [
    "https://www.lasportiva.com/it/stores",
    "https://www.lasportiva.com/it",
    "https://www.lasportiva.com/it/blog/",
    "https://www.lasportiva.com/it/blog/ambassadors"
]

CSV.foreach('csv/all_final.csv', { col_sep: ';' } ).each_with_index do |url, index|
    to = url[0].gsub('https://www.lasportiva.com','')

    begin
        puts "parsing #{index} of #{counting} - #{url[0]}"
        response = Net::HTTP.get_response(URI(url[0]))

        if response.code == '404'
            puts "Wrong redirect - #{url[0]} - check if new match"

            nresponse =  Net::HTTP.get_response(URI(url[1]))
            if nresponse.code == '200'
                puts "Puts new redirect"
                missing.push("#{to} #{url[1]}")
            else
                no_new_url.push("#{to} #{url[1]}")
            end
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