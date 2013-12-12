#!/usr/bin/env ruby
require 'pp'
require 'open-uri'
require 'watir'
require 'watir-webdriver'
require 'scraprr'


scraper = Scraprr::Scraper.new('div[skinpart=itemsContainer] > div').
  attribute(:name, 'div[skinpart=title]', :required => true).
  attribute(:abv, 'div[skinpart=description]', :regexp => /([0-9.]+)%/)

browser = Watir::Browser.new
browser.goto 'http://www.thetaphaus.co.nz/#!now-on-tap/c14a4'
sleep 10
document = Nokogiri::HTML(browser.html)
browser.close

pp scraper.extract(document)
