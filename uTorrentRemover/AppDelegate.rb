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
  attr_accessor :table
  attr_accessor :spinner

  def applicationDidFinishLaunching(a_notification)
    mapper = TCMPortMapper.sharedInstance
    center = NSNotificationCenter.defaultCenter

    center.addObserver self,
             selector: 'portMapperDidReceiveUPNPMappingTable:',
                 name: 'TCMPortMapperDidReceiveUPNPMappingTableNotification',
               object: mapper

    mapper.start
    mapper.requestUPNPMappingTable
  end
  
  def removeMappings sender
    TCMPortMapper.sharedInstance.requestUPNPMappingTable
    spinner.startAnimation self
  end

  def portMapperDidReceiveUPNPMappingTable notif
    objects = notif.userInfo['mappingTable'].map do |x|
      UPnPTableRow.new x['ipAddress'], x['description']
    end
    table.setContent objects

    spinner.stopAnimation self
  end
end

