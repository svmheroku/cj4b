# index.rb

require "rubygems"
require "bundler/setup"
require "nokogiri"
require "ruby-debug"

myf = File.open("tmp.html")

html_doc = Nokogiri::HTML(myf)

myf.close

td_elems = html_doc.search("td")

debugger

sz = td_elems.size

# Insert links inside each td-element:
td_elems.each{|td|
  # Change Week: 2011-01-31 Through 2011-02-04
  # to
  # /predictions/fx_past_wk2011_01_31
  debugger
  hhref = td.inner_html
}
