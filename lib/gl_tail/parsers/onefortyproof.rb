# gl_tail.rb - OpenGL visualization of your server traffic
# Copyright 2007 Erlend Simonsen <mr@fudgie.org>
#
# Licensed under the GNU General Public License v2 (see LICENSE)
#
# Hacked the fuck up by @jm3, 2010

# Parser which handles Rails access logs
class OnefortyproofParser < Parser
  def parse( line )
    #Completed in 0.02100 (47 reqs/sec) | Rendering: 0.01374 (65%) | DB: 0.00570 (27%) | 200 OK [http://example.com/whatever/whatever]
    if matchdata = /^Completed in ([\d.]+) .* \[([^\]]+)\]/.match(line)
    	_, ms, url = matchdata.to_a
      url = nil if url == "http:// /" # mod_proxy health checks?
    #Rails 2.2.2+: Completed in 17ms (View: 0, DB: 11) | 200 OK [http://example.com/etc/etc]
    elsif matchdata = /^Completed in ([\d]+)ms .* \[([^\]]+)\]/.match(line)
    	_, new_ms, url = matchdata.to_a
	ms = new_ms.to_f / 1000
	url = nil if url == "http:// /" # mod_proxy health checks?
    end

    if url
      _, host, url = /^http[s]?:\/\/([^\/]*)(.*)/.match(url).to_a
      host.gsub!(/bubblefusionlabs/, '140proof')

      add_activity(:block => 'sites', :name => host, :size => ms.to_f) # Size of activity based on request time.

      # humanize urls:
      short_url = case url
         when %r{/ads/user\.(xml|json)} then 'ad served'
         when %r{/impressions/verify\.(xml|json)} then 'ad shown'
         when %r{/test/ads\.(xml|json)} then 'developer test'
         else url
       end

      add_activity(:block => 'urls', :name => short_url, :size => ms.to_f)
      add_activity(:block => 'slow requests', :name => short_url, :size => ms.to_f)
      add_activity(:block => 'content', :name => 'ads served')

      # /ads/user.json?
      add_event(
        :block => 'impressions',
        :name => "Raw",
        :message => "",
        :update_stats => true,
        :color => [0.5, 1.0, 0.5, 1.0]) if url.include?('/ads/user.')

      # /impressions/verify.json?
      add_event(
        :block => 'impressions',
        :name => "Verified",
        :message => "",
        :update_stats => true,
        :color => [0.5, 1.0, 0.5, 1.0]) if url.include?('/impressions/verify.')

      # /retweets/verify.json?
      add_event(
        :block => 'retweets',
        :name => "Verified ReTweets",
        :message => "",
        :update_stats => true,
        :color => [0.5, 1.0, 0.5, 1.0]) if url.include?('/retweets/verify.')

      # /replies/verify.json?
      add_event(
        :block => 'replies',
        :name => "Verified Replies",
        :message => "",
        :update_stats => true,
        :color => [0.5, 1.0, 0.5, 1.0]) if url.include?('/replies/verify.')

      # /favorites/verify.json?
      add_event(
        :block => 'favorites',
        :name => "Verified Favorites",
        :message => "",
        :update_stats => true,
        :color => [0.5, 1.0, 0.5, 1.0]) if url.include?('/favorites/verify.')

    elsif line.include?('Processing ')
      #Processing TasksController#update_sheet_info (for 123.123.123.123 at 2007-10-05 22:34:33) [POST]
      _, host = /^Processing .* \(for (\d+.\d+.\d+.\d+) at .*\).*$/.match(line).to_a

      if host
        short_host = case host
          when /^(\d{1,3}\.){3}\d{1,3}$/ then 'unknown IP'
          when /blackberry.net/ then 'blackberry network'
          else host
         end
        add_activity(:block => 'users', :name => short_host)
      end

    elsif line.include?('Error (')
      _, error, msg = /^([^ ]+Error) \((.*)\):/.match(line).to_a
      if error
        add_event(:block => 'info', :name => "Exceptions", :message => error, :update_stats => true, :color => [1.0, 0.0, 0.0, 1.0])
        add_event(:block => 'info', :name => "Exceptions", :message => msg, :update_stats => false, :color => [1.0, 0.0, 0.0, 1.0])
        add_activity(:block => 'warnings', :name => msg)

      end
    end
  end
end
