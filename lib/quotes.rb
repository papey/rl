require 'faraday'

# Quotes contains everything to fetch and select a quote from a file or http
class Quotes
  attr_reader :data, :max_length

  def self.from_url(url, insecure: false, force_utf8: false)
    http = Faraday.new url, ssl: { verify: !insecure }
    resp = http.get
    raise StandardError, "Error getting url #{url} (status: #{resp.status})" unless resp.status == 200

    body = resp.body
    # gna gna gna href 😠
    body = body.force_encoding('UTF-8') if force_utf8

    new(body.split("\n").map(&:strip))
  end

  def self.from_file(path)
    new(File.readlines(path).map(&:strip).filter { |quote| !quote.empty? })
  end

  def initialize(data)
    @data = data
    @max_length = 270
  end

  def generate
    quote = data.sample
    return [quote] if quote.length <= max_length

    parts = []
    cursor = 0
    words = quote.split
    sentence = words.shift
    words.each do |word|
      candidate = "#{sentence} #{word}"
      if candidate.length <= max_length
        sentence = candidate
        next
      end

      parts[cursor] = sentence
      cursor += 1
      sentence = word
    end
    parts.push(sentence)
    parts
  end
end
