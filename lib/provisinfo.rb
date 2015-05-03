require 'provisinfo/version'
require 'provisinfo/provisioning'

module Provisinfo
  def self.process(provisioninFileName)
    p1 = Provisioning.new(provisioninFileName)
    puts "Name:"+p1.name
    puts "UUDID:"+p1.uuid       
  end
end
