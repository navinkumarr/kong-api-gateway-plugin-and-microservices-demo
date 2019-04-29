local BasePlugin = require "kong.plugins.base_plugin"
local cjson = require "cjson"
local constants = require "kong.plugins.demoauth.constants"
local utils = require "kong.plugins.demoauth.utils"
local kong_utils = require "kong.tools.utils"
local split = kong_utils.split

local type = type
local err_auth_failed = utils.err_auth_failed
local table_contains = kong_utils.table_contains
local kong = kong

local _realm = 'Key realm="' .. _KONG._NAME .. '"'

local DemoAuthHandler = BasePlugin:extend()

DemoAuthHandler.PRIORITY = constants.PRIORITY
DemoAuthHandler.VERSION = constants.VERSION

function DemoAuthHandler:new()
  DemoAuthHandler.super.new(self, "demoauth")
end

local function do_authentication(conf)
  if type(conf.key_names) ~= "table" then
    kong.log.err("[demo-auth] no conf.key_names set, aborting plugin execution")
    return false, {status = constants.STATUS.INTERNAL_SERVER_ERROR, message= constants.MESSAGE.INVALID_CONFIG}
  end

  local headers = kong.request.get_headers()
  local query = kong.request.get_query()

  -- search in headers & querystring
  local found, key = utils.find_auth_key(conf, headers, query)

  if not found then
    kong.response.set_header("WWW-Authenticate", _realm)
    return err_auth_failed()
  end

  local key_parts = split(key, "|")

  if table.getn(key_parts) < 2 then
    return err_auth_failed()
  end

  if key_parts[1] ~= "hackfest" or key_parts[2] ~= "demo" then
    return err_auth_failed()
  end

  return true
end

function DemoAuthHandler:access(conf)
  DemoAuthHandler.super.access(self)

  local ok, err = do_authentication(conf)
  if not ok then
    return kong.response.exit(err.status, utils.new_error(err.status, err.message))
  end
end

return DemoAuthHandler
