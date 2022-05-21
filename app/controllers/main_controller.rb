require 'net/dns'

class MainController < ApplicationController
  def index


  end

  def lookup
    # domain = params[:domain]
    domain = 'apple.com'
    puts "I have receievd #{params[:domain]}"

    $result = 10 + params[:domain].to_i
    puts $result

    resolve = Net::DNS::Resolver.new
    mx = resolve.mx(domain)

    

    puts "Here we go: "

    redirect_to root_path
  end
end
