# Run `ruby /vagrant/update_timestamps.rb` in the VM to
# update the commit and build mongodb data to increase by
# 24 hours. 
#
# Saves the trouble of having to manually update time stamps
# or pull new data in.

require 'rubygems'
require 'mongo'

client = Mongo::Client.new('mongodb://192.168.100.10:27017/dashboard')

# update the commits collection :timestamp and :scmCommitTimestamp by exactly 24 hours
update_timestamp = client[:commits].find.update_many("$inc" => { :timestamp => (86400*1000) } )
update_scmCommitTimestamp = client[:commits].find.update_many("$inc" => { :scmCommitTimestamp => (86400*1000) } )

# updates the build collection timestamps by exactly 24 hours
update_timestamp = client[:builds].find.update_many("$inc" => { :timestamp => (86400*1000) } )
update_startTime = client[:builds].find.update_many("$inc" => { :startTime => (86400*1000) } )
update_endTime = client[:builds].find.update_many("$inc" => { :endTime => (86400*1000) } )

## scratch
#commits.each do |i|
#  p i[:timestamp]
#  update_day = i[:timestamp]+(86400*1000*4)
#  p update_day
#
#end
