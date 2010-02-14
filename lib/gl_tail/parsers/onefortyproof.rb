# Parser for the 140 Proof API, based on the Apache parser
class OnefortyproofParser < Parser
  def parse( line )

    _, host, user, domain, date, url, status, size, referrer, useragent = /([\d\S.]+) (\S+) (\S+) \[([^\]]+)\] \"(.+?)\" (\d+) ([\S]+) \"([^\"]+)\" \"([^\"]+)\"/.match(line).to_a

    unless host
      _, host, user, domain, date, url, status, size = /([\d\S.]+) (\S+) (\S+) \[([^\]]+)\] \"(.+?)\" (\d+) ([\S]+)/.match(line).to_a
    end

    if host
      _, referrer_host, referrer_url = /^http[s]?:\/\/([^\/]+)(\/.*)/.match(referrer).to_a if referrer
      method, url, http_version = url.split(" ")
      url = method if url.nil?
      url, parameters = url.split('?')

      referrer.gsub!(/http:\/\//,'') if referrer

      add_activity(:block => 'servers', :name => server.name, :size => size.to_i) # Size of activity based on size of request

      short_url = case url
         when %r{/ads/user\.(xml|json)} then 'ad served'
         when %r{/impressions/verify\.(xml|json)} then 'ad shown'
         when %r{/clicks/create\.(xml|json)} then 'ad clicked'
         when %r{/test/ads\.(xml|json)} then 'developer test'
         else nil # suppress everything else
       end

      add_activity(:block => 'activity', :name => short_url) if short_url
      
      add_activity(:block => 'requests', :name => 'app requests')

      screen_name = "jm3"
      if parameters
        screen_name = parameters.split( /^.*user_id=([\w\d]+)&/ )[1]
      end
      add_activity(:block => 'audience', :name => "@#{screen_name}") if screen_name
      
      publisher = "yankly"
      if parameters
        publisher = parameters.split( /^.*publisher_id=([\w\d]+)&/ )[1]
      end
      add_activity(:block => 'app', :name => publisher) if publisher

      add_activity(:block => 'referrers', :name => referrer) unless (referrer.nil? || referrer_host.nil? || referrer_host.include?(server.name) || referrer_host.include?(server.host))

      ua = useragent || "unknown"
      ua.gsub!(/\/.*$/, '')
      ua.gsub!(/Black[Bb]erry(\d+.*$)/, "Blackberry #{$1}")
      add_activity(:block => 'platform', :name => ua) if ua.include?( 'Black' ) # once you go black...

      if( url.include?('.gif') || url.include?('.jpg') || url.include?('.png') || url.include?('.ico'))
        type = 'image'
      elsif url.include?('.css')
        type = 'css'
      elsif url.include?('.js')
        type = 'javascript'
      elsif url.include?('.swf')
        type = 'flash'
      elsif( url.include?('.avi') || url.include?('.ogm') || url.include?('.flv') || url.include?('.mpg') )
        type = 'movie'
      elsif( url.include?('.mp3') || url.include?('.wav') || url.include?('.fla') || url.include?('.aac') || url.include?('.ogg'))
        type = 'music'
      else
        type = 'page'
      end

      add_activity(:block => 'impressions', :name => 'Raw') if url.include?('/ads/user.')
      add_activity(:block => 'impressions', :name => 'Verified') if url.include?('/impressions/verify.')
      
      add_activity(:block => 'clicks', :name => 'Verified') if url.include?('/clicks/create.')
      add_activity(:block => 'retweets', :name => 'Verified') if url.include?('/retweets/verify.')
      add_activity(:block => 'favorites', :name => 'Verified') if url.include?('/favorites/verify.')
      add_activity(:block => 'replies', :name => 'Verified') if url.include?('/replies/verify.')

      add_activity(:block => 'status', :name => status, :type => 3) # don't show a blob

      add_activity(:block => 'warnings', :name => "#{status}: #{url}") if status.to_i > 400

    end
  end
end
