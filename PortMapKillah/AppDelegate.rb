#
#  AppDelegate.rb
#  PortMapKillah
#
#  Created by Mark Rada on 12-03-09.
#  Copyright 2012 Marketcircle Incorporated. All rights reserved.
#

class AppDelegate
  attr_accessor :window
  attr_accessor :refresh_button
  attr_accessor :kill_button
  attr_accessor :table
  attr_accessor :spinner

  def applicationDidFinishLaunching notif
    mapper = TCMPortMapper.sharedInstance
    center = NSNotificationCenter.defaultCenter

    center.addObserver self,
             selector: 'portMapperDidReceiveUPNPMappingTable:',
                 name: TCMPortMapperDidReceiveUPNPMappingTableNotification,
               object: mapper

    mapper.start
    mapper.requestUPNPMappingTable
  end

  def refreshMappings sender
    TCMPortMapper.sharedInstance.requestUPNPMappingTable
    spinner.startAnimation(self)
  end

  def removeMappings sender
    mappings = table.selectedObjects.map do |mapping|
      mapping.to_upnp_mapping
    end
    TCMPortMapper.sharedInstance.removeUPNPMappings mappings
    refreshMappings(self)
  end

  def portMapperDidReceiveUPNPMappingTable notif
    objects = notif.userInfo['mappingTable'].map do |x|
      UPnPTableRow.new *x.values
    end
    table.content = objects

    spinner.stopAnimation(self)
  end
end

