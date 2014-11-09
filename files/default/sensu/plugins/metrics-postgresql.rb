require 'rubygems' if RUBY_VERSION < '1.9.0'
# require 'sensu-plugin/metric/cli'
require 'pg'
require 'socket'


timestamp = Time.now.to_i

con     = PG::Connection.new(host, port, { sslmode: require }, nil, db, user, nil)
request = "SELECT COUNT(*) as count FROM users"
con.exec(request.join(' ')) do |result|
  pp result
  # result.each do |row|
  #   output "#{config[:scheme]}.bgwriter.checkpoints_timed", row['checkpoints_timed'], timestamp
  #   output "#{config[:scheme]}.bgwriter.checkpoints_req", row['checkpoints_req'], timestamp
  #   output "#{config[:scheme]}.bgwriter.buffers_checkpoint", row['buffers_checkpoint'], timestamp
  #   output "#{config[:scheme]}.bgwriter.buffers_clean", row['buffers_clean'], timestamp
  #   output "#{config[:scheme]}.bgwriter.maxwritten_clean", row['maxwritten_clean'], timestamp
  #   output "#{config[:scheme]}.bgwriter.buffers_backend", row['buffers_backend'], timestamp
  #   output "#{config[:scheme]}.bgwriter.buffers_alloc", row['buffers_alloc'], timestamp
  # end
end
