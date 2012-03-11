#
#  AppDelegate.rb
#  uTorrentRemover
#
#  Created by Mark Rada on 12-03-09.
#  Copyright 2012 Marketcircle Incorporated. All rights reserved.
#

class AppDelegate
  attr_accessor :window
  attr_accessor :button

  def applicationDidFinishLaunching(a_notification)
    mapper = TCMPortMapper.sharedInstance
    center = NSNotificationCenter.defaultCenter

    center.addObserver self,
             selector: 'portMapperDidReceiveUPNPMappingTable:',
                 name: 'TCMPortMapperDidReceiveUPNPMappingTableNotification',
               object: mapper

    mapper.start
  end
  
  def removeMappings sender
    TCMPortMapper.sharedInstance.requestUPNPMappingTable
  end

  def portMapperDidReceiveUPNPMappingTable notif
    NSLog(notif.userInfo.inspect)
  end
end

