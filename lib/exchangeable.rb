require 'viewpoint'

# Exchangeable is handling some basic stuff to communicate with an exchange server

class Exchangeable
  def initialize(endpoint, username, password)
    @client = Viewpoint::EWSClient.new endpoint, username, password
  end

  # Checke if it is possible to authenticate
  def authenticated?
    return true if @client.folders.count
  rescue Viewpoint::EWS::Errors::UnauthorizedResponseError
    return false
  end
end
