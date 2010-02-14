# Parser for MySQL slow query logs
class MysqlSlowParser < Parser
  def parse( line )

    # # Time: 100213 20:42:49
    # # User@Host: root[root] @ domU-12-31-39-07-49-51.compute-1.internal [10.209.74.159]
    # # Query_time: 0  Lock_time: 0  Rows_sent: 1  Rows_examined: 1
    # SELECT * FROM `impressions`  LIMIT 1;
    if line.include? "# Time: "
      _, ms, time = /^# Time:\s+(.+) ([0-9:]+)$/.match(line).to_a

      if ms
        add_activity(:block => 'queries', :name => 'Slow-ass Query', :size => ms.to_i)
        add_event(:block => 'info', :name => "Pokey", :message => ms + ' ms', :update_stats => false, :color => [1.0, 0.0, 0.0, 1.0])
      end

    elsif line.include? "# User@Host: " # no use for this yet
    elsif line.include? "# Query_time: "
      # Query_time: 0  Lock_time: 0  Rows_sent: 1  Rows_examined: 1
      _, query_time, lock_time, rows_sent, rows_examined = /^# Query_time: ([0-9]+)\s+Lock_time: ([0-9]+)\s+Rows_sent: ([0-9]+)\s+Rows_examined: ([0-9]+)/.match(line).to_a

      add_activity(:block => 'rows', :name => 'sent', :size => rows_sent.to_i)
      add_activity(:block => 'rows', :name => 'examined', :size => rows_examined.to_i)
      # not sure how best to tally these: query_time,lock_time
    else
      _, query_type = /^(\w+)/.match(line).to_a
      unless /\d+/.match(query_type)
        add_activity(:block => 'query_type', :name => query_type, :size => 1)
        puts line
      end
    end

  end
end
