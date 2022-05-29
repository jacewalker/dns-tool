

class MainController < ApplicationController
  def index
  end

  def lookup
    require 'net/dns'
    @domain = params[:domain].downcase
    @seenBefore = ''
    
    ## Removed as :type has been hidden in lookup.html.erb
    # @type = params[:type].downcase

    nameservers = [
      "8.8.8.8",
      "8.8.4.4",
      "1.1.1.1",
      "1.0.0.1",
      "9.9.9.9",
      "149.112.112.112",
      "185.228.168.9",
      "185.228.169.9",
      "76.76.19.19",
      "76.223.122.150",
      "94.140.14.14",
      "94.140.15.15"
    ]

    @res = Net::DNS::Resolver.new

    ## Checks if the host is alive via A Record
    if @res.query(@domain, Net::DNS::A, Net::DNS::IN).answer.empty?
      "Error: Invalid domain entry, failed A Record lookup."
      redirect_to root_path, alert: "Domain not found, please try again."
    else 
      @soa = @res.query(@domain, Net::DNS::SOA, Net::DNS::IN).answer
      @soa.empty? ? @res.nameservers = nameservers[rand(0..nameservers.count-1)] : @res.nameservers = soaNS(@soa)
      
      @a = @res.query(@domain, Net::DNS::A, Net::DNS::IN).answer
      @mx = @res.query(@domain, Net::DNS::MX, Net::DNS::IN).answer
      @ns = @res.query(@domain, Net::DNS::NS, Net::DNS::IN).answer
      
      txtUnmapped = @res.query(@domain, Net::DNS::TXT, Net::DNS::IN).answer
      txtMapped = txtUnmapped.each.map { |r| r.txt }
      @txt = txtUnmapped.zip(txtMapped)
      @whoisData = whoisLookup(@domain)
      updateDNSRecordsToDatabase
    end
    
  end

  def soaNS(soa)
    soa[0].to_a[4].split[0] ? domain = soa[0].to_a[4].split[0] : 'google.com'
    return ip = @res.query(domain, Net::DNS::A, Net::DNS::IN).answer[0].to_a[4]
  end

  def whoisLookup(domain)
    require 'whois'

    ## Warning: API Limits
    c = Whois::Client.new
    return c.lookup(domain).to_s.split("\r\n")

  end

  def updateDNSRecordsToDatabase
    if DnsLookup.find_by(domain: @domain) 
      @seenBefore = 'True'
      @dnsDB = DnsLookup.new
      lastSeen = DnsLookup.find_by(domain: @domain)
      @dnsDB.aRecord = @a unless lastSeen.aRecord == @a
      @dnsDB.mxRecord = @mx unless lastSeen.mxRecord == @mx
      @dnsDB.txtRecord = @txt unless lastSeen.txtRecord == @txt
      @dnsDB.soaRecord = @soa unless lastSeen.soaRecord == @soa
      @dnsDB.nsRecord = @ns unless lastSeen.nsRecord == @ns
      @dnsDB.save
    else
      @seenBefore = 'False'
      @dnsDB = DnsLookup.new
      @dnsDB.domain = @domain
      @dnsDB.aRecord = @a
      @dnsDB.mxRecord = @mx
      @dnsDB.txtRecord = @txt
      @dnsDB.soaRecord = @soa
      @dnsDB.nsRecord = @ns
      @dnsDB.save
    end

    



  end

end
