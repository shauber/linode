#!/usr/bin/ruby

require 'rubygems'
require 'linode'
require 'net/http'

APIKEY = "yourLinodeAPIKEY"
DOMAIN_ID = '123456'
RESOURCE_ID = '123456'
IP_CHECK = 'checkip.dyndns.com'

linode = Linode.new(:api_key => APIKEY)
res = linode.domain.resource.list(:DomainId => DOMAIN_ID, :ResourceId => RESOURCE_ID)[0]
puts res.target

Net::HTTP.start(IP_CHECK, 80) do |http|
  myIP = http.get('/').body.match(/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/)
  if !myIP.eql?(res.target)
    res.target = myIP
    linode.domain.resource.update(res.marshal_dump)
  end
end
