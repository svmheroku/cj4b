#
# index_spec.rb
#

# Usage:
# bundle exec rspec index_spec.rb

# I use this script to generate a list of a-tags like this:
# Week: 2011-02-20 Through 2011-02-25

# The a-tags will land in this file:
# /pt/s/rl/bikle101/app/views/predictions/_us_stk_past_spool.html.erb
# which is a partial in this file:
# /pt/s/rl/bikle101/app/views/predictions/us_stk_past.haml

# Each a-tag will take me to a set of reports for a specific week.
# The reports will show:
# - Action (buy or sell) summaries
# - pair summaries
# - Details of all predictions

# Here is some haml which serves as a demo of what I want an a-tag to look like:
# %a(href="/predictions/us_stk_past_wk2011_02_20")
#   Week: 2011-02-20 Through 2011-02-25

# I use us_stk_past.sql to get the data via a join of 3 types of tables:
# prices,gains
# gatt-scores
# gattn-scores

require "../spec_helper"

describe "cj helps me build both erb files and haml files which act as Rails templates" do

  it "rvm should give me the correct version of Ruby and correct set of Gems" do
    `which rvm`.should == "/oracle/.rvm/bin/rvm\n"
    `rvm list`.should include "ruby-1.9.2-head [ x86_64 ]"
    `rvm gemset list`.should include "=> gs1"
    `which ruby`.should include "/oracle/.rvm/rubies/ruby-1.9.2-head/bin/ruby"
    `ruby -v`.should include "ruby 1.9.2p188 (2011-03-28 revision 31204) [x86_64-linux]"
  end
##

  it "Should run the sql script us_stk_past.sql" do
    `which sqt`.should == "/pt/s/rl/cj/bin/sqt\n"
    # `/bin/ls -l us_stk_past.sql`.should == "-rw-r--r-- 1 oracle oinstall 50 2011-05-17 22:43 us_stk_past.sql\n"
    # The script should have an exit so it will not hang:
    `grep exit us_stk_past.sql`.should match /^exit\n/
    time0 = Time.now
    sql_output = `sqt @us_stk_past.sql`
    # The sql script should need at least 3 seconds to finish:
    # (Time.now - time0).should > 2
    sql_output.should match /^Connected to:\n/
    sql_output.should match /^Oracle Database 11g Enterprise Edition /
    sql_output.should match /us_stk_past.sql/
    sql_output.should match /^Recyclebin purged/
    sql_output.should match /^@us_stk_past_week.sql 2011-05-09/
    sql_output.should match /^Disconnected from Oracle Database 11g /
    # I should see 2 recent spool files:
    (Time.now - File.ctime("/tmp/_us_stk_past_spool.html.erb")).should < 9
    (Time.now - File.ctime("/tmp/us_stk_past_week.txt")).should < 9
    # Do a small edit:
    `grep -v 'rows selected' /tmp/_us_stk_past_spool.html.erb > /tmp/tmp_us_stk.html`
    (Time.now - File.ctime("/tmp/tmp_us_stk.html")).should < 2
  end
##

  # Use Nokogiri to massage the HTML in tmp_us_stk.html and redirect it into the partial full of a-tags.
  # The partial is here:
  # /pt/s/rl/bikle101/app/views/predictions/_fx_past_spool.html.erb
  # The partial is rendered in this file: 
  # app/views/predictions/fx_past.haml

  it "Should Use Nokogiri to transform tmp_us_stk.html into the partial full of a-tags." do
    myf = File.open("/tmp/tmp_us_stk.html")
    html_doc = Nokogiri::HTML(myf)
    myf.close
    td_elems = html_doc.search("td")
    # I should see at least 1 row of history.
    td_elems.size.should > 0

    # Insert links inside each td-element:
    td_elems.each{|td|
      # Change Week: 2011-01-31 Through 2011-02-04
      # to
      # /predictions/us_stk_past_wk2011_01_31
      hhref_tail = td.inner_html.gsub(/\n/,'').sub(/Week: /,'').sub(/ Through .*$/,'').gsub(/-/,'_')
      hhref="/predictions/us_stk_past_wk#{hhref_tail}"
      td.inner_html = "<a href='#{hhref}'>#{td.inner_html.gsub(/\n/,'')}</a>"
    }
    # Im done, write it to the Rails partial:
    fhw = File.open("/pt/s/rl/bikle101/app/views/predictions/_us_stk_past_spool.html.erb","w")
    fhw.write(html_doc.search("table#table_us_stk_past").to_html)
    fhw.close

  end
##

  it "Should Fill each of the partials with data." do
    # Start by pulling some syntax out of us_stk_past_week.txt
    # which was created by my call to us_stk_past.sql
    `grep us_stk_past_week.sql /tmp/us_stk_past_week.txt > /tmp/run_us_stk_past_week.sql`

    `echo exit >> /tmp/run_us_stk_past_week.sql`
    (Time.now - File.ctime("/tmp/run_us_stk_past_week.sql")).should < 2
    # I should see more than 5 SQL calls in /tmp/run_us_stk_past_week.sql:
    `cat /tmp/run_us_stk_past_week.sql|wc -l`.chomp.to_i.should > 5
    p "Now calling sqlplus:"
    p "sqt @/tmp/run_us_stk_past_week.sql"
    sql_output = `sqt @/tmp/run_us_stk_past_week.sql`
    sql_output.should match /^Connected to:\n/
    sql_output.should match /^Oracle Database 11g Enterprise Edition /
    sql_output.should match /us_stk_past_week.sql/
    sql_output.should match /rows selected/
    sql_output.should match /^Disconnected from Oracle Database 11g /

    # I start by getting a list of spool files created by sqlplus:
    glb = Dir.glob("/tmp/tmp_us_stk_past_week_20*.lst").sort
    glb.size.should > 4

  end
##

end
