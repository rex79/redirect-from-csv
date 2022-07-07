require 'yaml'
require 'CSV'


redirect_path = []
CSV.foreach('full_redirect.csv', { col_sep: ';' } ) do |redirect|
  puts redirect.inspect
  redirect_from = redirect[0].gsub("https://www.lasportiva.com", "")

  obj = {
    "#{redirect_from}": {
      to: "#{redirect[1]}",
      code: 301
    }
  }
  redirect_path.push(obj)
end
=begin
CSV.foreach('redirect_it.csv', { col_sep: ';' } ) do |redirect|
  redirect_from = redirect[0].gsub("https://www.lasportiva.com", "")

  obj = {
    "#{redirect_from}": {
      to: "#{redirect[1]}",
      code: 301
    }
  }
  redirect_path.push(obj)
end
=end
final_redirect = [
  {
    "http://{default}/": {
      type: "upstream",
      upstream: "mymagento:http"
    },
    "http://{all}/": {
      type: "upstream",
      redirects: {
        paths: redirect_path
      }
    }
  }
]
output = File.open("routes_final.yaml", "w")
output.write(final_redirect.to_yaml)
output.close
