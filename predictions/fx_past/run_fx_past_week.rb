#
# run_fx_past_week.rb
#

# I use this script to loop through spool files created by sqlplus.

require 'rubygems'
require "bundler/setup"
require "nokogiri"
# require 'ruby-debug'

# I start by getting a list of spool files created by sqlplus:
glb = Dir.glob("/tmp/tmp_fx_past_week_20*.lst").sort

glb.each{|fn|

  # For each file, make note of the date embedded in the filename.
  # The date should be a Sunday.
  # I use the date to identify a weeks worth of data:
  the_date = fn.sub(/tmp_fx_past_week_/,'').sub(/.lst/,'').gsub(/-/,'_').sub(/\/.*\//,'')

  # generate bread_crumbs from the_date
  bread_crumbs = "Site Map > Predictions > Forex > Past Forex Predictions #{the_date}"
  site_map    = '<a href="/r10/site_map">Site Map</a>'
  predictions = '<a href="/predictions">Predictions</a>'
  forex       = '<a href="/predictions/fx">Forex</a>'
  past_forex_predictions = '<a href="/predictions/fx_past">Past Forex Predictions</a>'
  bread_crumbs = "#{site_map} > #{predictions} > #{forex} > #{past_forex_predictions} > Week of: #{the_date}"

  # generate h5-element from the_date
  h5_element = "<h5>Week of: #{the_date}</h5>"

  # Next, I feed the file to Nokogiri so I can access HTML in the file:
  # html_doc = open(fn){ |f| Hpricot(f) }
  myf = File.open(fn)
  html_doc = Nokogiri::HTML(myf)
  myf.close

  # Generate some a-elements from th-elements.
  th_elems = html_doc.search("th")

  th_elems.each {|elm| 
    ei_h =   elm.inner_html
    ei_hclass = ei_h.gsub(/\n/,'').gsub(/\<br\>/,'').gsub(/\<br \/>/,'').gsub(/ /,'').downcase
    elm.inner_html = "<a href='#' class='#{ei_hclass}'>#{ei_h}</a>"
  }

  # Load some html into a string:
  some_html = html_doc.search("table.table_fx_past_week").to_html

  # I want a file for this URL pattern:
  # href="/predictions/fx_past_wk2011_01_30"
  html_f = File.new("/pt/s/rl/bikle101/app/views/predictions/fx_past_wk#{the_date}.html.erb", "w")
  # Fill the file with HTML which I had obtained from sqlplus:
  html_f.puts bread_crumbs + h5_element + some_html
  p "#{html_f.path} File written"
  html_f.close
}
