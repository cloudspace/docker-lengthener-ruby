require 'uri'
require 'net/http'

def fetch(uri_str, limit = 20)
  # You should choose a better exception.
  raise ArgumentError, 'too many HTTP redirects' if limit == 0
  response = Net::HTTP.get_response(URI(uri_str))
  case response
  when Net::HTTPRedirection then
    location = response['location']
    fetch(location, limit - 1)
  else
    uri_str
  end
end

puts fetch(ARGV[0])