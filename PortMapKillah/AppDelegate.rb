#
#  AppDelegate.rb
#  PortMapKillah
#
#  Created by Mark Rada on 12-03-09.
#  Copyright 2012 Marketcircle Incorporated. All rights reserved.
#

class AppDelegate
  KILL_LIST  = []
  KILL_QUEUE = Dispatch::Queue.new 'com.ferrous26.PortMapKillah.kill_queue'

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

    scheduleKilling
  end

  def scheduleKilling
    KILL_QUEUE.async do
      sleep 300
      killMappings!
      scheduleKilling
    end
  end

  def refreshMappings sender
    TCMPortMapper.sharedInstance.requestUPNPMappingTable
    spinner.startAnimation(self)
  end

  def removeMappings sender
    KILL_LIST.concat table.selectedObjects.map(&:to_upnp_mapping)
    killMappings!
  end

  def killMappings!
    NSLog("Removing mappings for #{KILL_LIST.inspect}")
    TCMPortMapper.sharedInstance.removeUPNPMappings KILL_LIST
    refreshMappings(self)
  end

  def portMapperDidReceiveUPNPMappingTable notif
    table.setContent notif.userInfo['mappingTable'].map { |x|
      UPnPTableRow.new *x.values
    }

    spinner.stopAnimation(self)
  end
end

