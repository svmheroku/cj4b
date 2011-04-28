# index.rb

require "rubygems"
require "bundler/setup"
require "nokogiri"
require "ruby-debug"

debugger

x = 1

# doc = open("tmp.html") { |f| Hpricot(f) }

myf = File.open("tmp.html")

html_doc = Nokogiri::HTML(myf)

myf.close

mth = html_doc.methods

# p mth.to_s

td_elems = html_doc.search("td")

sz = td_elems.size
