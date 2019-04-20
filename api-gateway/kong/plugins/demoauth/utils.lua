local constants = require "kong.plugins.shaadiauth.constants"

local _M = {}

function _M.new_error(status, message)
  status = status or 401
  message = message or "Authorization Required"
  local error_response = {
    error= {
      status= status,
      message= message,
      message_shortcode= "authorization_required",
      datetime= "",
      url= "",
      qs= "",
      type= "UnauthorizedException",
      group= "gateway"
    }
  }
  return error_response
end

function _M.err_auth_failed()
  return false, { status = constants.STATUS.UNAUTHORIZED, message = constants.MESSAGE.AUTHORIZATION_REQUIRED}
end

function _M.find_auth_key(conf, headers, uri_args)
  local key
  for i = 1, #conf.key_names do
    local name = conf.key_names[i]
    local v = headers[name]
    if not v then
      -- search in querystring
      v = uri_args[name]
    end

    if type(v) == "string" and v ~= "" then
      key = v
      break
    elseif type(v) == "table" then
      return false
    end
  end

  if not key then
    return false
  end

  return true, key
end

return _M
