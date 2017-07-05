#!/usr/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'pry'

class Listing
	attr_reader :title
	attr_reader :price
	attr_reader :is_auction
	attr_reader :site
end

class TractorHouseListing < Listing
	def initialize(listing)
		begin
			@title = listing.at_css("div.listing-name > a").text
			list_price = listing.at_css("div.listing-price-first > span.nobr")
			if list_price == nil
				@price = "Call"
			else
				@price = list_price.text.gsub(/^USD/, "").delete(",$ ")
			end
			@desc = listing.css("div.equip-details")[0].text
			@is_auction = false
			@site = "Tractor House"
		rescue
			puts "Something went wrong"
			puts listing.serialize
			binding.pry
		end
	end
end

alllistings = []

url = 'https://www.tractorhouse.com/listings/farm-equipment/for-sale/list/category/1108/tractors-175-hp-or-greater/manufacturer/agco-allis?sortorder=7&SCF=False'
doc = Nokogiri::HTML(open(url))
listings = doc.css('div.listings-list > div.cf > div.listing')
listings.each do |l|
	alllistings << TractorHouseListing.new(l)
end
binding.pry
