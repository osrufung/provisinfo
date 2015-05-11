require 'plist'
require 'json'
require 'date'


class Provisioning
  attr_accessor :name
  attr_accessor :type
  attr_accessor :uuid
  attr_accessor :appID
  attr_accessor :teamID  
  attr_accessor :filename
  attr_accessor :expirationDate
  
  #by default, it will load the first .mobileprovision file in current directory
  def initialize(filename = nil)   
    if filename.nil?
	    @filename = self.class.list_files().first 
	  else
      @filename = filename
    end	   
  
    if @filename
	    self.load_from_file()  	    
    else
      @name ="Unknown"
    end
	  
  end
  
  def load_from_file()    
    xml_raw = `security cms -D -i #{@filename}` 
	  xml_parsed = Plist::parse_xml(xml_raw)   
    @teamID = xml_parsed['Entitlements']['com.apple.developer.team-identifier']
	  @name = xml_parsed['Name']
	  @uuid = xml_parsed['UUID']    
	  @appID = xml_parsed['Entitlements']['application-identifier']
    @expirationDate = xml_parsed['ExpirationDate']
  

  end
 
  def self.list_files()
    provisioning_file_paths = []
	  Dir.entries('.').each do |path|
	    provisioning_file_paths << path if path=~ /.*\.mobileprovision$/
	  end
	  provisioning_file_paths
  end
  
  def is_expired()
    now = DateTime.now
    return self.expirationDate < now
  end

  def show_info()
    puts "Name:"+self.name
    puts "UUDID:"+self.uuid 
    puts "AppID:"+self.appID 
    puts "TeamID:"+self.teamID
    puts "ExpirationDate:"+self.expirationDate.strftime("%c")
    
  end 
  
end
  
  
if __FILE__ == $0
  #p1 = Provisioning.new('failed.mobileprovision')
  #p1.show_info()  
end  