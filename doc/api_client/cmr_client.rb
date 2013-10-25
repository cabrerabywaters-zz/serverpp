#!/usr/bin/env ruby

# Require Savon gem to conect to PuntosPoint API
begin require('savon')
  # Defining PuntosPoint location
  endpoint = 'http://107.22.255.20'

  # Defining Header Authentication Token
  authentication = nil

  # Defining WSDL location
  wsdl = "#{endpoint}/api/cmr/events/wsdl"

  # Checking correctly entered endpoint location
  if endpoint.nil?
    warn "Please enter the endpoint location, around line: 6"
    exit
  end

  # Checking correctly entered authentication token
  if authentication.nil?
    warn "Please enter the correct authentication token, around line: 9"
    exit
  end

  # Creating an instance of Savon Client
  # More information: http://savonrb.com/version2/
  client = Savon.client(wsdl: wsdl, headers: {"Authentication" => authentication})

  # Getting a list of PuntosPoint API operations
  client.operations

  # Calling GetEvents operation
  response = client.call(:get_events)

  # Now your <response> contain an XML of all available Events for EFI (with Authentication Token <authentication>)
rescue LoadError => err
  warn 'Please install savon gem before run it'
end

exit