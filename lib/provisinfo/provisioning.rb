require 'plist'
require 'json'
require 'date'

require "openssl"
require "rexml/document"
 
RED = 31
GREEN = 32

def puts_message(color, code, text)
  puts "[ \e[#{color}m#{code.upcase}\e[0m ] #{text}"
end

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
	    @filename = self.class.list_provisioning_files().first 
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
 
  def self.list_provisioning_files()
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
  
  def validate(certificate_filename, password)

    if certificate_filename.nil? or not File.exists?(certificate_filename)
      abort("can't find the certificate file.")
    end

    profile = File.read(self.filename)
    certificate = File.read(certificate_filename)
    p7 = OpenSSL::PKCS7.new(profile)
    cert = OpenSSL::PKCS12.new(certificate, password)
    store = OpenSSL::X509::Store.new
    p7.verify([], store)

    plist = REXML::Document.new(p7.data)
    plist.elements.each('/plist/dict/key') do |ele|
    if ele.text == "DeveloperCertificates"
      keys = ele.next_element
      key = keys.get_elements('//array/data')[0].text

      key = key.scan(/.{1,64}/).join("\n")

      profile_cert = "-----BEGIN CERTIFICATE-----\n" + key.gsub(/\t/, "") + "\n-----END CERTIFICATE-----\n"
      
      @provisioning_cert = OpenSSL::X509::Certificate.new(profile_cert)
    end
  end
  
  if @provisioning_cert.to_s != cert.certificate.to_s
    puts_message(RED, "error", "Provisioning profile was not signed with provided certificate.")

    exit 1
  else
    puts_message(GREEN, "passed", "Provisioning profile signature validation passed.")
  
    exit 0
  end
  end

 end
  
  
if __FILE__ == $0

  # failed test case
  # p1 = Provisioning.new('failed.mobileprovision')
  # p1.show_info()  

  # Validation case
    p1 = Provisioning.new('3WKJWX.mobileprovision')
    p1.validate('3WKJWX.p12','')
 

end  