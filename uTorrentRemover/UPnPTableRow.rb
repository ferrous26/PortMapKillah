#
#  UPnPTableRow.rb
#  uTorrentRemover
#
#  Created by Mark Rada on 12-03-10.
#  Copyright 2012 Marketcircle Incorporated. All rights reserved.
#

class UPnPTableRow
  attr_accessor :ip_address
  attr_accessor :description
  
  def initialize ip, desc
    @ip_address  = ip
    @description = desc
  end

end