#!/usr/bin/env ruby

require_relative "fetcher"


unless ARGV.length == 1
  print "\n\nSupply a stock symbol like: GOOG, AAPL, LUV, YUM, HOG, BUD, BA\n\n"
  exit
end

@sym = {stock_symbol: ARGV[0].upcase}
report = Fetchers::Stock.new(@sym)
report.fetch

print "\n\nHTTP Status: ", report.message, "\n\n"

if (report.data[:exchange] == "UNKNOWN EXCHANGE")
  print "Unknown Stock Symbol\n\n"
  exit
end

print "Symbol:      ", @sym[:stock_symbol], " (", report.data[:exchange], ")\n"
print "Company:     ", report.data[:company], "\n"
print "Last price:  $", report.data[:last_price], "\n"
print "Volume:      ", report.data[:volume], " shares\n"
print "Mkt Cap:     $", report.data[:market_cap], "B\n"
print "Change:      ", report.data[:percent_change], "%\n"
print "URL:         ", report.data[:url], "\n"
print "\n\n"
