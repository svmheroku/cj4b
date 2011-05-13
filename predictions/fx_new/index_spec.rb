#
# index_spec.rb
#

# Usage:
# bundle exec rspec index_spec.rb

# I use this script to generate a partial full of new predictions.

require "/pt/s/rl/cj/spec_helper.rb"

describe "cj helps me build both erb files and haml files which act as Rails templates" do

  it "rvm should give me the correct version of Ruby and correct set of Gems" do
    `which rvm`.should == "/oracle/.rvm/bin/rvm\n"
    `rvm list`.should include "ruby-1.9.2-head [ x86_64 ]"
    `rvm gemset list`.should include "=> gs1"
    `which ruby`.should include "/oracle/.rvm/rubies/ruby-1.9.2-head/bin/ruby"
    `ruby -v`.should include "ruby 1.9.2p188 (2011-03-28 revision 31204) [x86_64-linux]"
  end
##

  it "Should run the sql script fx_new.sql" do
    `which sqt`.should == "/pt/s/rl/cj/bin/sqt\n"
    # `/bin/ls -l fx_new.sql`.should == "hello"
    # The script should have an exit so it will not hang:
    `grep exit fx_new.sql`.should match /^exit\n/
    time0 = Time.now
    sql_output = `sqt @fx_new.sql`
    # The sql script should need at least 3 seconds to finish:
    # (Time.now - time0).should > 2
    sql_output.should match /^Connected to:\n/
    sql_output.should match /^Oracle Database 11g Enterprise Edition /
    sql_output.should match /fx_new.sql/
    sql_output.should match /^Disconnected from Oracle Database 11g /
    # I should see a recent spool file:
    (Time.now - File.ctime("/tmp/_fx_new_spool.html.erb")).should < 9
    # Do a small edit:
    `grep -v 'rows selected' /tmp/_fx_new_spool.html.erb > /tmp/tmp.html`
    (Time.now - File.ctime("/tmp/tmp.html")).should < 2
  end
##

  # I Use Nokogiri to massage the HTML in tmp.html and redirect it into a partial holding a table-element.
  # The partial is here:
  # /pt/s/rl/bikle101/app/views/predictions/_fx_new_spool.html.erb
  # The partial is rendered in this file: 
  # app/views/predictions/fx_new.haml

  it "Uses Nokogiri to massage tmp.html into a partial holding a table-element." do
pending "some work"
  end
##

end
