# index.rb

require "rubygems"
require "bundler/setup"
require "nokogiri"
# require "ruby-debug"

myf = File.open("/tmp/tmp.html")

html_doc = Nokogiri::HTML(myf)

myf.close

td_elems = html_doc.search("td")

sz = td_elems.size

# Insert links inside each td-element:
td_elems.each{|td|
  # Change Week: 2011-01-31 Through 2011-02-04
  # to
  # /predictions/fx_past_wk2011_01_31
  hhref_tail = td.inner_html.gsub(/\n/,'').sub(/Week: /,'').sub(/ Through .*$/,'').gsub(/-/,'_')
  hhref="/predictions/fx_past_wk#{hhref_tail}"
  td.inner_html = "<a href='#{hhref}'>#{td.inner_html.gsub(/\n/,'')}</a>"
}

# Im done, print it now so my shell can redirect the HTML into a file:
print html_doc.search("table#table_fx_past").to_html
