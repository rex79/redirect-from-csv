require 'csv'

tpl_top = "if (req.url.path ~ \"[src]\") {"
tpl_middle = "error [ecount]";
tpl_close = "}"

tpl1_top = "if (obj.status == [ecount] ) {"
tpl1_mid1 = "set obj.status = 301;"
tpl1_mid2 = "set obj.http.Location = req.http.host \"[dest]\";"
tpl1_close = "}"


src_array = []
ecount = 2000
CSV.foreach('redirect_ksn1.csv', { col_sep: ';'}).each_with_index do |url, index|
    src_array.push({ src: tpl_top.gsub("[src]", url[0]), dest: tpl1_mid2.gsub("[dest]", url[1]), count_index: ecount } )
    ecount += 1
end

recv_file = File.open('recv.txt', 'w')
error_file = File.open('error.txt','w')
src_array.each do |redir|
    recv_file.puts redir[:src] +"\r"
    recv_file.puts tpl_middle.gsub("[ecount]",redir[:count_index].to_s)
    recv_file.puts tpl_close

    error_file.puts tpl1_top.gsub("[ecount]", redir[:count_index].to_s) +"\r"
    error_file.puts tpl1_mid1 +"\r"
    error_file.puts redir[:dest] +"\r"
    error_file.puts tpl1_close
end
recv_file.close
error_file.close