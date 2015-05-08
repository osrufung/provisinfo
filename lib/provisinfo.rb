require 'provisinfo/version'
require 'provisinfo/provisioning'

module Provisinfo
  def self.show_info(provisioninFileName)
    p1 = Provisioning.new(provisioninFileName)
    p1.show_info()         
  end
end
