#!/usr/bin/env ruby

require 'optparse'
require 'twitter'
require_relative '../lib/quotable'
require_relative '../lib/quotes'

MAX_THREAD_LEN = 10

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: rl.rb [options]'

  opts.on('-u', '--url=URL', 'Quote source url (--url as higher priority over --file') { |u| options[:url] = u }
  opts.on('-k', '--insecure', 'Skip certificate validation for --url option') { |k| options[:insecure] = k }
  opts.on('-f', '--file=PATH', 'Path to quote source file') { |f| options[:file] = f }
end.parse!

%w[CONSUMER_KEY CONSUMER_SECRET ACCESS_TOKEN ACCESS_TOKEN_SECRET].each do |key|
  raise "#{key} environment value not found" unless ENV[key]
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['CONSUMER_KEY']
  config.consumer_secret     = ENV['CONSUMER_SECRET']
  config.access_token        = ENV['ACCESS_TOKEN']
  config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

raise 'No source selected' unless options[:file] || options[:url]

quotes = Quotes.from_file(options[:file]) if options[:file]
quotes = Quotes.from_url(options[:url], insecure: options[:insecure], force_utf8: true) if options[:url]

quote = quotes.generate

if quote.empty? || (quote.length > MAX_THREAD_LEN)
  raise "Invalid thread, max length is #{MAX_THREAD_LEN} tweets (current length is #{quote.length})"
end

# raw string, just one tweet and exit
if quote.length == 1
  client.update quote.first.surround
  exit 0
end

# array, multiple tweets
# first tweet starts the thread
thread = client.update(quote.shift.open)

# continue the thread as needed
quote[0...-1].each do |part|
  thread = client.update(part.continue, in_reply_to_status_id: thread.id)
end

# close it
client.update(quote[-1].close, in_reply_to_status_id: thread.id)
