require 'net/dns'

class MainController < ApplicationController
  def index

  end

  def lookup
    @domain = params[:domain].downcase
    @type = params[:type].downcase

    @a = Net::DNS::Resolver.start(@domain).answer
    @mx = Net::DNS::Resolver.start(@domain, Net::DNS::MX).answer
    @ns = Net::DNS::Resolver.start(@domain, Net::DNS::NS).answer
  end


end
