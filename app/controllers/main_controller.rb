require 'net/dns'

class MainController < ApplicationController
  def index

  end

  def lookup
    # domain = params[:domain]
    # puts "I have recieved #{params[:domain]}"

    domain = 'google.com.au' # temp override for testing
    
    $a = Net::DNS::Resolver.start("google.com.au").answer[0]
    $mx = Net::DNS::Resolver.start("google.com.au", Net::DNS::MX).answer
    $ns = Net::DNS::Resolver.start("google.com.au", Net::DNS::NS).answer

    redirect_to root_path
  end
end
