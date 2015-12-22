require 'provisinfo/version'
require 'provisinfo/provisioning'

module Provisinfo
  def self.show_info(provisioningFileName)
    p1 = Provisioning.new(provisioningFileName)
    p1.show_info()         
  end

  def self.validate(provisioningFileName,certificateFileName)
  	p1 = Provisioning.new(provisioningFileName)
  	p1.validate(certificateFileName)
  end
end
