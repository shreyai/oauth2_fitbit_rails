module Oauth2Rails
  module Errors
    # 400 Bad Request    | Any case where either endpoint doesn't exist,
    #                    |  resource path parameters are invalid, POST request
    #                    |  parameters are invalid or no Authentication header provided.
    #                    |  This doesn't include invalid specific resource ids
    # 401 Unauthorized   | The OAuth Authorization header provided and is invalid
    #                    |  (consider looking in response body). Client or authorized
    #                    |  user have no privilege to view requested data (for example,
    #                    |  requested resource's owner has privacy permission "You" or "Friends"
    #                    |  for requested resource)
    # 404 Not Found      | The resource with given id doesn't exist
    # 409 Conflict       | Either you hit the rate limiting quota for the client or
    #                    |  for the viewer, or you trying to create conflicting resources (consider looking at errorType)
    # 500 Internal Error | Something is terribly wrong on our side (and we are working on it). Try your request later
    # 502 Bad Gateway    | We will be back soon. Maintenance!

    class BadRequest < StandardError
    end

    class Unauthorized < StandardError
    end

    class NotFound < StandardError
    end

    class Conflict < StandardError
    end

    class InternalServer < StandardError
    end

    class BadGateway < StandardError
    end

    class InvalidArgument < StandardError
    end

  end
end