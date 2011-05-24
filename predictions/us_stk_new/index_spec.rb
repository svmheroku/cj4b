#
# index_spec.rb
#

# Usage:
# bundle exec rspec index_spec.rb

# I use this script to create a partial full of new DanBot-scores from US Stock prices.

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

  it "Should run the sql script us_stk_new.sql" do
    `which sqt`.should == "/pt/s/rl/cj/bin/sqt\n"
    # The script should have an exit so it will not hang:
    `grep exit us_stk_new.sql`.should match /^exit\n/
  end
##
end

