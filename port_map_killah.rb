#!/usr/bin/env macruby

framework 'Cocoa'
framework 'TCMPortMapper'
load_bridge_support_file 'TCMPortMapper.bridgesupport'


class UPnPMapping
  attr_reader :ip_address, :public_port, :local_port, :protocol, :description

  # @param [Hash]
  def initialize data
    @ip_address, @public_port, @local_port, @protocol, @description =
      data.values_at('ipAddress','publicPort','localPort','protocol','description')
  end

  def inspect
    "#@protocol://#@ip_address:#@public_port (#@description)"
  end

  def to_upnp_mapping
    { 'protocol' => protocol, 'publicPort' => public_port }
  end
end


class Killah
  attr_accessor :mapper
  attr_accessor :patterns

  def initialize patterns
    @patterns = patterns.map { |pattern| Regexp.new pattern }
    NSLog("Killing mappings with descriptions matching: #{@patterns.inspect}")

    @mapper   = TCMPortMapper.sharedInstance
    @mapper.start
    NSNotificationCenter.defaultCenter.addObserver self,
                                         selector: 'portMapperDidReceiveUPNPMappingTable:',
                                             name: TCMPortMapperDidReceiveUPNPMappingTableNotification,
                                           object: @mapper
  end

  def portMapperDidReceiveUPNPMappingTable notif
    mappings = notif.userInfo['mappingTable'].collect { |mapping|
      mapping = UPnPMapping.new mapping
      NSLog("Found mapping: `#{mapping.inspect}'")
      mapping
    }

    @mapper.removeUPNPMappings kill_list_for mappings
  end
  alias_method :kill_mappings!, :portMapperDidReceiveUPNPMappingTable

  def schedule_killing
    NSLog('Updating mappings list')
    @mapper.requestUPNPMappingTable
    performSelector 'schedule_killing', withObject: nil, afterDelay: 60
  end


  private

  def kill_list_for mappings
    mappings.select { |mapping|
      @patterns.any? { |x| mapping.description.match x }
    }.map! { |mapping|
      NSLog("Removing mapping `#{mapping.inspect}'")
      mapping.to_upnp_mapping
    }
  end
end


KILLAH = Killah.new ARGV
KILLAH.schedule_killing
NSRunLoop.currentRunLoop.run

