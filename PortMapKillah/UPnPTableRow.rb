#
#  UPnPTableRow.rb
#  PortMapKillah
#
#  Created by Mark Rada on 12-03-11.
#  Copyright 2012 Marketcircle Incorporated. All rights reserved.
#

class UPnPTableRow
  attr_accessor :ip_address
  attr_accessor :public_port
  attr_accessor :local_port
  attr_accessor :protocol
  attr_accessor :description
  attr_accessor :autokill
  alias_method  :autokill?, :autokill

  def initialize ip, pub, local, proto, desc
    @ip_address   = ip
    @public_port  = pub
    @local_port   = local
    @protocol     = proto
    @description  = desc
    @autokill     = false
  end
  
  def to_upnp_mapping
    {
      'protocol'   => protocol,
      'publicPort' => public_port
    }
  end
end
