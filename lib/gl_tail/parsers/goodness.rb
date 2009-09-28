class GoodnessParser < Parser

  # Stored Tweet Id 4451603705 => DB id 1363211
  # Skipped Tweet Id 4451604095 because no gratitude found 
  # Skipped Tweet Id 4451600001 because not an @reply

  def parse( line )
    _, skipped_or_stored, tweet = /(Skipped|Stored) Tweet Id (\d+)/.match(line).to_a
    return unless line =~ /(Skipped|Stored)/

    #add_activity(:block => 'sites', :name => host, :size => ms.to_f) # Size of activity based on request time.
    #add_activity(:block => 'urls', :name => HttpHelper.generalize_url(url), :size => ms.to_f)
    #add_activity(:block => 'slow requests', :name => HttpHelper.generalize_url(url), :size => ms.to_f)
    #add_activity(:block => 'content', :name => 'page')
    
    if skipped_or_stored.eql?( "Stored" )
      add_activity(:block => 'content', :name => 'created', :size => 1, :type => 3) # do something with tweet
      add_event(:block => 'info', :name => "Create", :message => "+", :update_stats => true, :color => [0.5, 1.0, 0.5, 1.0])
    else
      _, because = /.* because (.*)$/.match(line).to_a
      add_activity(:block => 'content', :name => because, :size => 1, :type => 3)         
      add_event(:block => 'info', :name => "Skip", :message => "X", :update_stats => true, :color => [1.5, 0.0, 0.0, 1.0])
    end
  end   

end