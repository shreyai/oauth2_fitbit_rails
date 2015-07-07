require 'oauth2_rails/version'

module Oauth2Rails
  extend self
  def new
    Client.new()
  end
end

# => OVERALL STUCTURE
# module Oauth2Rails
#   class Base
#     has base gets and posts
#   end
#
#   class Auth < Base
#     has the authentication requirements
#   end
#
#   class Api < Base
#     makes api calls, should be easily extendable
#   end
#
#   class User
#     makes fetching user information easier
#   end
#
#   class Errors
#     error messages
#   end
# end
