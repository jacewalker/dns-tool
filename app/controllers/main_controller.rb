require 'net/dns'

class MainController < ApplicationController
  def index

  end

  def lookup
    domain = params[:domain]

    puts "I have receievd #{domain}"

  end
end
