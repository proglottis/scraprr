#!/usr/bin/env ruby
require 'pp'
require 'open-uri'
require 'scraprr'

scraper = Scraprr::Scraper.new('table tr').
  attribute(:brewery, './td[1]', :required => true).
  attribute(:url, './td[1]/a', :attr => 'href', :required => true).
  attribute(:year, './td[3]').
  attribute(:production, './td[4]')

document = Nokogiri::HTML(open('http://en.wikipedia.org/wiki/Trappist_beer'))
pp scraper.extract(document)
