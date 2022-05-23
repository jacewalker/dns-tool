require 'net/dns'

class MainController < ApplicationController
  def index

  end

  def lookup
    @domain = params[:domain].downcase
    @type = params[:type].downcase

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
    @res.nameservers = nameservers[rand(0..nameservers.count-1)]

    @a = @res.query(@domain, Net::DNS::A, Net::DNS::IN).answer
    @mx = @res.query(@domain, Net::DNS::MX, Net::DNS::IN).answer
    @ns = @res.query(@domain, Net::DNS::NS, Net::DNS::IN).answer
    @soa = @res.query(@domain, Net::DNS::SOA, Net::DNS::IN).answer

    @txtUnmapped = @res.query(@domain, Net::DNS::TXT, Net::DNS::IN).answer
    @txtMapped = @txtUnmapped.each.map { |r| r.txt }
    @txt = @txtUnmapped.zip(@txtMapped)

  end


end
