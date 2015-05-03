require 'plist'

class Provisioning
  attr_accessor :name
  attr_accessor :type
  attr_accessor :uuid
  attr_accessor  :appID
  attr_accessor :filename
  
  #by default, it will load the first .mobileprovision file in current directory
  def initialize(filename = nil)   
    if filename.nil?
	    @filename = self.class.list_files().first 
	  else
      @filename = filename
    end	   
  
    if @filename
	    self.load_from_file(@filename)  	    
    else
      @name ="Unknown"
    end
	  
  end
  
  def load_from_file(filepath)
    @filename = filepath
    xml_raw = `security cms -D -i #{@filename}`
	xml_parsed = Plist::parse_xml(xml_raw)
	@name = xml_parsed['Name']
	@uuid = xml_parsed['UUID']
	@appID = xml_parsed['application-identifier']

  end
 
  def self.list_files()
    provisioning_file_paths = []
	Dir.entries('.').each do |path|
	  provisioning_file_paths << path if path=~ /.*\.mobileprovision$/
	end
	provisioning_file_paths
  end
end
  