require 'mysportsfeeds'

class MySportsFeedsService

  attr_reader :data

  def initialize(player_name)
    filtered = player_name.gsub(" ","-").downcase
    msf = MySportsFeeds.new(version="1.0", true)
    msf.authenticate(ENV["MSF_Username"],ENV["MSF_Password"])
    @data = msf.msf_get_data( 'nba',
                              '2016-2017-regular',
                              'cumulative_player_stats',
                              'json',
                              'player' => "#{filtered}"
                            )
  end
end
