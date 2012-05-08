# Two of the projects we'll be discussing are heavily dependent on code like the example below, which
# requests stock price information from Google's finance API and transforms the results into a hash 
# for use in our database. This pattern shows up over and over in my projects. I always setup a separate 
# codebase containing a bunch of worker" modules that just do stuff like this.
#
# I need to write a bunch more of these for a variety of data sources. My plan is to start you off 
# on these, then graduate to more complex features.
#
# Here are two things for you to try:
#
# 1) Look through http://programmableweb.com for publicly-accessible APIs that you'd like to experiment with. 
# Write a class like the one below that pulls data from them and converts the results into a hash.
#
# 2) If you're feeling really ambitious, sign up for a Microsoft Bing Maps Key, and write a class that counts 
# the number of severe traffic incidents occurring in and around Baltimore, MD. The Bing traffic API is
# documented here:
#
# http://msdn.microsoft.com/en-us/library/hh441726.aspx
#
# I also found that MapQuest has a nice API that could be easier to work with:
#
# http://www.mapquestapi.com/traffic/

# Here's the stock example:

require_relative "base"
require "nokogiri"

module Fetchers
   class Stock < Base
    BASE_URL = "http://www.google.com"
 
    def fetch
        http_request("#{BASE_URL}/ig/api?stock=#{@cue[:stock_symbol]}") do |body|
        quote = Nokogiri::XML(body)

        company = quote.xpath("//company").attribute("data").value
        market_cap = quote.xpath("//market_cap").attribute("data").value
        exchange = quote.xpath("//exchange").attribute("data").value
        last_price = quote.xpath("//last").attribute("data").value
        volume = quote.xpath("//volume").attribute("data").value
        percent_change = quote.xpath("//perc_change").attribute("data").value
        url = BASE_URL + quote.xpath("//symbol_lookup_url").attribute("data").value

        @data = {
          company: company,
          market_cap: market_cap,
          exchange: exchange,
          last_price: last_price,
          volume: volume,
          percent_change: percent_change,
          url: url
        }

      end
    end
  end
end


# Note that Fetchers::Stock inherits from a class called Fetchers::Base which provides some common behavior
# for all fetchers. That class is below for your reference. 

# For your first whack at this I recommend starting in a more simple way. Just use Ruby's built-in Net::HTTP
# library (instead of typhoeus) to fetch the results from Bing. You will need to use nokogiri or Ruby 1.9's 
# built-in JSON parser to convert the results of your query into something Ruby can process.

